require 'ruby_parser'

module Roffle
  module Parser
    def self.parse(path)
      file = File.read(path)
      parser = RubyParser.for_current_ruby
      parser.parse(file, path)
    end
  end
end
