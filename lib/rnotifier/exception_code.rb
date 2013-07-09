module Rnotifier
  class ExceptionCode
    class << self

      def get(backtrace)
        return unless backtrace
        bline = backtrace.find do |l| 
          l.index(Config.app_env[:app_root]) == 0 && !Gem.path.any?{|path| l.index(path) == 0}
        end
        filename, line, method = (bline|| backtrace[0]).split(':')
        self.find(filename, line.to_i, 3)
      end

      def find(filename, line_no, wrap_size = 1)
        s_range = [line_no - wrap_size, 1].max - 1
        e_range = line_no + wrap_size - 1
        code = [s_range]

        begin
          File.open(filename) do |f|
            f.each_with_index do |line, i|
              code << line if i >= s_range && i <= e_range
              break if i > e_range
            end
          end
        rescue Exception => e
        end
        code
      end
    end

  end
end
