require 'fileutils.rb'


module GitTest
  # takes a path, a name (file name) and a report
  # makes directory if not present
  # writes the given report to the file name in that path
  class Writer
    attr_accessor :report, :path, :name, :notify

    def initialize(options, notify = Notify.new)
      self.path   = options[:path]
      self.name   = options[:name]
      self.report = options[:report]
      self.notify = notify
    end


    def mkdir!
      FileUtils.mkdir_p(path)
    end
    
    def full_path
      File.join(path, name)
    end

    def write_report_to_disk!
      mkdir!
      File.open(full_path, 'w') {|f| f.write(report) }
    end

    def self.save(*args)
      self.new(*args).save
    end

    def save
      notify.start("Writing report to #{full_path}")
      write_report_to_disk!
    end
    alias :save! :save

    def show_report
      system "open #{}"
    end
  end
end