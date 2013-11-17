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
      if args.count < 2
        puts "Usage: #{BINARY_NAME} <refactoring> <path> [<options>]"
        exit 1
      end

      refactoring, file, options = args
      source = SourceLocation.from_options_string(file)

      case refactoring
      when ExtractMethod.short_name
        output = ExtractMethod.apply(source, *options)
        puts RubyWriter.to_ruby(output)
      else
        puts "#{BINARY_NAME}: '#{refactoring}' is not a valid refactoring."
        exit 1
      end
    end
  end
end
