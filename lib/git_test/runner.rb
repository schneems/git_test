require 'time'

module GitTest
  # orchestrates everything
  class Runner
     attr_accessor :notify, :options, :proj, :test_proj, :test, :writer, :test_dir

     def initialize(options ={} , notify = Notify.new)
       self.options  = options
       self.notify   = notify
       self.proj     = GitTest::Proj.new(options)
       self.test     = GitTest::Test.new(options)
       self.test_dir = Dir.mktmpdir(".git_test_#{proj.current_branch}_#{Time.now.to_i}")
       clone_to_test!
     end

     # runs the test command provided
     def test!
       in_test_dir do
         proj.check_repo_status!
         notify.start("Running tests on: #{proj.current_branch}")
         test.run!
         notify.done("Test finished: #{test.status}", test.passed?)
       end
     end

     # will open the specified or  last report
     def show_report(file_name = nil, branch = current_branch)
       file_name ||= last_report_file_name(branch)
       report = proj.show(report_branch, File.join(report_path(branch), file_name))
       report_file = Tempfile.new([report_name, report_extension])
       report_file.write(report)
       exec "open #{report_file.path}"
       sleep 300
     end

     # gives last report file name
     def last_report_file_name(branch = current_branch)
       ls_report_dir(branch).first
     end

     # outputs the files in the test directory for a given branch
     def ls_report_dir(branch = current_branch)
       files = proj.show(report_branch, report_path(branch)).split("\n")
       files.shift(2)
       files
     end


     # cleans up the temp directory
     def clean_test_dir!
       FileUtils.remove_entry_secure test_dir
     end

     # pushes to origin on the current branch and report branch
     def push!
       notify.write("Pushing to origin")
       proj.push('origin', proj.current_branch)
       proj.push('origin', report_branch) if proj.is_branch? report_branch
     end

     # pulls from origin on the current branch and report branch
     def pull!
       notify.write("Pulling from origin")
       proj.pull('origin', proj.current_branch)
       proj.pull('origin', report_branch) if proj.is_branch? report_branch
     end

     # writes the result of the test command to disk
     def write_report!
       notify.critical_error("Must run `test!` before writing a report") if test.status.nil?
       in_test_branch do
         self.writer  = GitTest::Writer.new(:path   => report_path,
                                            :name   => report_name,
                                            :report => test.report )
         writer.save!
         commit_to_test_proj!
       end
     end

     # commits contents of test branch and pushes back to local repo
     def commit_to_test_proj!
       test_proj.add
       result = test_proj.commit("#{proj.current_branch} #{report_name}")
       notify.write("Pushing back to local repo")
       puts "================="
       puts test_proj.current_branch
       puts report_branch
       puts proj.repo
       puts test_proj
       test_proj.push(proj.repo, report_branch)
     end

     private

     def full_report_path
       File.join(report_path, report_name)
     end

     def report_branch
       "git_test_reports"
     end

     def report_path(branch = proj.current_branch)
       "git_test_reports/#{branch}"
     end

     def report_name
       name =  "#{ test.created_at.utc.iso8601 }_"
       name << "#{ proj.username }_"
       name << "#{ test.status }#{ report_extension }"
     end

     def current_branch
       proj.current_branch
     end



     def report_extension
       ".#{test.format}"
     end


     def clone_to_test!
       self.test_proj = proj.clone_to_test(test_dir)
     end

     def in_test_dir(&block)
       Dir.chdir(test_dir) do
         yield
       end
     end

     def in_test_branch(branch = report_branch, &block)
       in_test_dir do
         branch = test_proj.branch(branch)
         branch.checkout
         test_proj.checkout(branch)
         yield
         test_proj.checkout(proj.current_branch)
       end
     end
   end
end