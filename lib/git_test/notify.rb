module GitTest
  class Notify
    class TextFormat
      attr_accessor :length, :msg, :filler
      ENGINE = "#=="
      CABOOSE = "==#"
      FILL_CHAR = "="

      def initialize(msg, length)
        self.msg    = " #{msg} "
        self.length = length
      end

      def filler_length_needed
        length - (ENGINE.length + CABOOSE.length + msg.length)
      end

      def filler_per_side
        filler_length_needed/2.0
      end

      def odd?
        !even?
      end

      def even?
        filler_per_side % 2 == 0
      end

      def message_too_long?
        filler_length_needed < 0
      end

      # def truncate_message!
      #   self.msg # = msg[0, msg.length + filler_length_needed - 3 ] << "..."
      # end

      def add_filler!
        filler = filler_per_side.floor.times.map {FILL_CHAR}.join("")
        # result = if even?
        #         self.msg = "#{filler}#{msg}#{filler}"
        #       else
        #         self.msg = "#{filler}#{msg}#{filler}#{FILL_CHAR}"
        #       end
      end

       def output
         "#{ENGINE}#{msg}"
       end

      def normalize
        add_filler!
        output
      end

    end
    attr_accessor :output

    def initialize(output = STDOUT)
      self.output = output
    end

    def start(msg)
      write(msg, :light_blue)
    end

    def sentiment(msg, bool = true)
      write(msg, bool ? :green : :red)
    end

    def done(msg, passed = true)
      sentiment(msg, passed)
    end

    def critical_error(msg, exit_code = -1)
      write(msg, :red)
      exit! exit_code
    end

    def write(msg, color = :light_yellow, truncate = 80)
      msg = TextFormat.new(msg, truncate).normalize
      output.puts "#{msg}".send color
    end
  end
end