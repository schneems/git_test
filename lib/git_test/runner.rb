module GitTest
  # orchestrates everything else
  # initializes writer, proj, test
  # moves files

  # runner = GitTest::Runner.new(options)
  # runner.push!
  # runner.test!
  # runner.write_report!
  # runner.push!
  class Runner
     attr_accessor :notify, :options, :proj, :test_proj, :test, :writer, :test_dir

     def initialize(options ={} , notify = Notify.new)
       self.options  = options
       self.notify   = notify
       self.proj     = GitTest::Proj.new(options)
       self.test     = GitTest::Test.new(options)
       self.test_dir = Dir.mktmpdir(".git_test_#{proj.branch}_#{Time.now.to_i}")
       clone_to_test!
     end

     def test!
       in_test_dir do
         proj.check_repo_status!
         notify.start("Running tests on: #{proj.branch}")
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

     def clean_test_dir!
       FileUtils.remove_entry_secure test_dir
     end

     def push!
       notify.write("Pushing to origin")
       proj.push('origin', proj.branch)
     end

     def pull!
       notify.write("Pulling from origin")
       proj.pull('origin', proj.branch)
     end

     def write_report!
       notify.critical_error("Must run `test!` before writing a report") if test.status.nil?
       in_test_branch("git_test_reports/#{test_proj.branch}") do
         self.writer  = GitTest::Writer.new(:path   => "/",
                                            :name   => report_name,
                                            :report => test.report )
         writer.save!
         commit_to_test_proj!
       end
     end

     def commit_to_test_proj!
       test_proj.add
       test_proj.commit("#{proj.branch} report_name")
       test_proj.push(proj.path, test_proj.branch)
     end



     private
     def report_name
       name =  "#{ test.created_at.iso8601 }_"
       name << "#{ proj.username }_"
       name << "#{ test.result }.#{ test.format }"
     end


     def clone_to_test!
       self.test_proj = proj.clone_to_test(test_dir)
     end

     def in_test_dir(&block)
       Dir.chdir(test_dir) do
         yield
       end
     end

     def in_test_branch(branch, &block)
       in_test_dir do
         test_proj.branch(branch)
         test_proj.checkout(branch)
         yield
         test_proj.checkout(proj.branch)
       end
     end
   end
end