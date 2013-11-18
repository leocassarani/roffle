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
        halt "Usage: #{BINARY_NAME} <refactoring> <path> [<options>]"
      end

      refactoring, file, options = args

      unless klass = refactoring_class(refactoring)
        halt "#{BINARY_NAME}: '#{refactoring}' is not a valid refactoring."
      end

      perform_refactoring(klass, file, options)
    end

    private

    def refactoring_class(refactoring)
      case refactoring
      when ExtractMethod.short_name
        ExtractMethod
      else
        nil
      end
    end

    def perform_refactoring(klass, file, options)
      source = SourceLocation.from_string(file)
      sexp   = Parser.parse(source.path)
      output = klass.apply(sexp, source, *options)
      puts RubyWriter.to_ruby(output)
    end

    def halt(str)
      puts str
      exit 1
    end
  end
end
