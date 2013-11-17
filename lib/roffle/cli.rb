require 'roffle'

module Roffle
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
        ExtractMethod.apply(source, *options)
      else
        puts "#{BINARY_NAME}: '#{refactoring}' is not a valid refactoring."
        exit 1
      end
    end
  end
end
