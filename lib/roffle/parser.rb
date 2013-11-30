require 'ruby_parser'

module Roffle
  module Parser
    def self.parse(path)
      file = File.read(path)
      sexp = parser.parse(file, path)
      SexpTree.new(sexp)
    end

    def self.parser
      @parser ||= RubyParser.for_current_ruby
    end
  end
end
