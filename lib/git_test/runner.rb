require 'time'

module GitTest
  # orchestrates everything
  class Runner
     attr_accessor :notify, :options, :proj, :test_proj, :test, :writer, :test_dir

     def initialize(options ={} , notify = Notify.new)
       self.options     = options
       self.notify      = notify
       self.proj        = GitTest::Proj.new(options)
       self.test        = GitTest::Test.new(options)
       self.proj_branch = proj_branch
       self.test_dir    = Dir.mktmpdir(".git_test_#{proj_branch}_#{Time.now.to_i}")
       prepare_proj_for_test!
       clone_to_test!
     end

     def prepare_proj_for_test!
       proj.check_repo_status!
       proj.branch(report_branch) unless proj.is_branch? report_branch
     end

     # runs the test command provided
     def test!
       in_test_dir do
         notify.start("Running tests on: #{proj_branch}")
         test.run!
         notify.done("Test finished: #{test.status}", test.passed?)
       end
     end

     # will open the specified or  last report
     def show_report(file_name = nil, branch = proj_branch)
       file_name ||= last_report_file_name(branch)
       report = proj.show(report_branch, File.join(report_path(branch), file_name))
       report_file = Tempfile.new([report_name, report_extension])
       report_file.write(report)
       exec "open #{report_file.path}"
       sleep 300
     end

     # gives last report file name
     def last_report_file_name(branch = proj_branch)
       ls_report_dir(branch).first
     end

     # outputs the files in the test directory for a given branch
     def ls_report_dir(branch = proj_branch)
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
       proj.push('origin', proj_branch)
       proj.push('origin', report_branch)
     end

     # pulls from origin on the current branch and report branch
     def fetch!
       notify.write("Pulling from origin")
       proj.fetch(proj_branch)
     end

     # writes the result of the test command to disk
     def write_report!
       notify.critical_error("Must run `test!` before writing a report") if test.status.nil?
       in_test_dir do
         self.writer  = GitTest::Writer.new(:path   => report_path,
                                            :name   => report_name,
                                            :report => test.report )
         in_report_branch do
           writer.save!
           commit_to_test_proj!
         end
       end
     end

     # commits contents of test branch and pushes back to local repo
     def commit_to_test_proj!
       test_proj.add(full_report_path)
       result = test_proj.commit("#{proj_branch} #{report_name}")
       notify.write("Pushing back to local repo")
       test_proj.real_pull('origin', report_branch)
       test_proj.push('origin', report_branch)
     end

     private

     def full_report_path
       File.join(report_path, report_name)
     end

     def report_branch
       "git_test_reports"
     end

     def report_path(branch = proj_branch)
       "git_test_reports/#{branch}"
     end

     def report_name
       name =  "#{ test.created_at.utc.iso8601 }_"
       name << "#{ test_proj.username }_"
       name << "#{ test.status }#{ report_extension }"
     end



     def report_extension
       ".#{test.format}"
     end


     def clone_to_test!
       clone = proj.clone_to_test(test_dir)
       self.test_proj = GitTest::Proj.new(:path => clone.dir.to_s)
     end

     def in_test_dir(&block)
       Dir.chdir(test_dir) do
         yield
       end
     end

     def in_report_branch(branch = report_branch, &block)
       in_test_dir do
         branch = test_proj.branch(branch)
         branch.checkout
         test_proj.checkout(branch)
         yield
       end
     end
   end
end