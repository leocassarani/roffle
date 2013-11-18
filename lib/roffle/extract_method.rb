require_relative 'sexp_transformation'

module Roffle
  class ExtractMethod
    def self.short_name
      'extract-method'
    end

    def self.apply(sexp, source, new_name)
      new(sexp, source).apply(new_name)
    end

    attr_reader :source, :sexp

    def initialize(sexp, source)
      @sexp = sexp
      @source = source
    end

    def apply(new_name)
      new_name = new_name.to_sym

      lines = source.lines
      extracted = sexp_slice(lines)
      replacement = replace_with_method_call(lines, new_name)

      s(:block, replacement,
        s(:defn, new_name, s(:args), *extracted))
    end

    private

    def sexp_slice(lines)
      source_map = SourceMap.new(sexp)
      source_map.at_lines(lines)
    end

    def replace_with_method_call(lines, method)
      t = SexpTransformation.new(sexp)
      t.replace_lines(lines, method_call(method))
    end

    def method_call(name)
      s(:call, nil, name)
    end
  end
end
