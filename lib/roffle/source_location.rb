module Roffle
  SourceLocation = Struct.new(:path, :lines) do
    class << self
      def from_string(str)
        path, lines = str.split(':')
        first, last = lines.split('-')
        range = line_range(first, last)
        new(path, range)
      end

      private

      def line_range(first, last)
        first = Integer(first)

        if last.nil?
          first..first
        else
          first..Integer(last)
        end
      end
    end
  end
end
