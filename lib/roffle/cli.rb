require 'ruby_parser'

module Roffle
  class Cli
    def self.run(args)
      new(args).run
    end

    def initialize(args)
      @args = args
    end

    def run
      if @args.count < 2
        STDERR.puts "Usage: roffle <refactoring> <path>"
        exit 1
      end

      refactoring, file = @args.take(2)
      parser = RubyParser.for_current_ruby
      sexp = parser.parse(File.binread(file), file)
      puts sexp.inspect
    end
  end
end
