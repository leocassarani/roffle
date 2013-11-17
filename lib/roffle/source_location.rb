module Roffle
  SourceLocation = Struct.new(:path, :line) do
    def self.from_options_string(str)
      path, line = str.split(':')
      new(path, line.to_i)
    end
  end
end
