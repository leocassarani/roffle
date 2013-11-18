module Roffle
  class ExtractMethod
    def self.short_name
      'extract-method'
    end

    def self.apply(source, new_name)
      new(source).apply(new_name)
    end

    attr_reader :source

    def initialize(source)
      @source = source
      @sexp = Parser.parse(source.path)
    end

    def apply(new_name)
      new_name = new_name.to_sym
      lines = source.lines

      source_map = SourceMap.new(@sexp)
      extracted = source_map.at_lines(lines)

      s(:block, replace(lines, method_call(new_name)),
        s(:defn, new_name, s(:args), *extracted))
    end

    private

    def replace(lines, after)
      replaced = false

      ary = @sexp.inject([]) do |acc, obj|
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
