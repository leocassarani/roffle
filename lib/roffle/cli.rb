require 'roffle'

module Roffle
  module RubyWriter
    def self.to_ruby(sexp)
      sexp.inspect
    end
  end

  class Cli
    BINARY_NAME = "roffle"

    def self.run(args)
      new(args).run
    end

    attr_reader :args

    def initialize(args)
      @args = args
    end

    def run
      if args.count < 2
        puts "Usage: #{BINARY_NAME} <refactoring> <path> [<options>]"
        exit 1
      end

      apply_refactoring
    end

    def apply_refactoring
      refactoring, file, options = args
      source = SourceLocation.from_string(file)
      sexp = Parser.parse(source.path)

      case refactoring
      when ExtractMethod.short_name
        output = ExtractMethod.apply(sexp, source, *options)
        puts RubyWriter.to_ruby(output)
      else
        puts "#{BINARY_NAME}: '#{refactoring}' is not a valid refactoring."
        exit 1
      end
    end
  end
end
