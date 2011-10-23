module GitTest
  class Proj < Git::Base
    attr_accessor :notify
    def initialize(options = {}, notify = Notify.new)
      self.notify = notify
      path =  options[:path]||"."
      super :working_directory => path
    end

    def username
      config["user.name"]
    end

    # add
    # commit("this is my commit message")


    def show(branch, file)
      self.lib.send :command, "show", "#{branch}:#{file}"
    end


    def real_pull(remote = 'origin', branch = 'master')
      check_repo_status!
      self.lib.send :command, 'pull', [remote, branch]
    end

    def check_repo_status!
      repo_status_checked = true
    end

    def path
      dir.to_s
    end

    # def test_directory
    #   File.join(path, '..', ".tmp-git-test-dir-for-#{repo_name}")
    # end

    def repo_name
      path.split('/').last
    end

    def clone_to(path)
      Git.clone(self.repo, path)
    end
    alias :clone_to_test :clone_to
  end
end