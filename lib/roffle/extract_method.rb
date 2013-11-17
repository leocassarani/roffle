require 'ruby_parser'

module Roffle
  class ExtractMethod
    def self.short_name
      'extract-method'
    end

    def self.apply(source, new_name)
      new(source).apply(new_name)
    end

    attr_reader :source, :sexp

    def initialize(source)
      @source = source
      @sexp = parse(source.path)
    end

    def apply(new_name)
      new_name = new_name.to_sym
      to_extract = sexp_at_line(source.line)
      replacement = s(:call, nil, new_name)
      remainder = sexp_replace(sexp, to_extract, replacement)

      s(:block, remainder,
        s(:defn, new_name, s(:args), *to_extract))
    end

    private

    def parse(path)
      file = File.read(path)
      parser = RubyParser.for_current_ruby
      parser.parse(file, path)
    end

    def sexp_at_line(line)
      match = []
      sexp.each_sexp do |s|
        match << s if s.line == line
      end
      match
    end

    def sexp_replace(sexp, before, after)
      sexp = sexp.sub(before.first, after)
    end

    def s(*args)
      Sexp.new(*args)
    end
  end
end
