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
      replacement = sexp_replace(lines, method_call(new_name))

      s(:block, replacement,
        s(:defn, new_name, s(:args), *extracted))
    end

    private

    def sexp_slice(lines)
      source_map = SourceMap.new(sexp)
      source_map.at_lines(lines)
    end

    def sexp_replace(lines, after)
      replaced = false

      ary = sexp.inject([]) do |acc, obj|
        if Sexp === obj && lines.include?(obj.line)
          if replaced
            acc
          else
            replaced = true
            acc + [after]
          end
        else
          acc + [obj]
        end
      end

      Sexp.from_array(ary)
    end

    def method_call(name)
      s(:call, nil, name)
    end
  end
end
