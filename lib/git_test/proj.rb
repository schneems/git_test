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

    alias :pull_original :pull

    def pull(*args)
      check_repo_status!
      pull_original *args
    end
    # pull

    def check_repo_status!
      notify.critical_error "Files have been changed commit them to proceed"  unless status.changed.empty?
      notify.critical_error "Files have been added commit them to proceed"    unless status.added.empty?
      notify.critical_error "Files have been deleted commit them to proceed"  unless status.deleted.empty?
      true
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