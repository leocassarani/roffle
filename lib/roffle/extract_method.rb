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
      @sexp = Parser.parse(source.path)
    end

    def apply(new_name)
      new_name = new_name.to_sym

      source_map = SourceMap.new(sexp)
      extracted = source_map.at_line(source.line)

      s(:block, sexp_replace(sexp, extracted, method_call(new_name)),
        s(:defn, new_name, s(:args), *extracted))
    end

    private

    def sexp_replace(sexp, before, after)
      sexp.sub(before.first, after)
    end

    def method_call(name)
      s(:call, nil, name)
    end

    def s(*args)
      Sexp.new(*args)
    end
  end
end
