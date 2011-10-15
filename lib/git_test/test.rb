module GitTest
  class Test
    attr_accessor :report, :result, :status, :notify, :created_at, :command, :exit_code
    def initialize(options = {}, notify = Notify.new)
      self.notify     = notify
      self.created_at = Time.now
      self.command    = options[:cmd]
    end

    def format
      :html
    end

    def passed?
      exit_code == 0
    end

    def failed?
      !passed?
    end

    def run!
      self.report = %x{#{command}}
      self.exit_code = Integer($?)
      self.status = passed? ? "passed" : "failed"
    end
  end
end