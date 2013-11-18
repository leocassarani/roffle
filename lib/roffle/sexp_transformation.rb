module Roffle
  class SexpTransformation
    attr_reader :sexp

    def initialize(sexp)
      @sexp = sexp
    end

    def replace_lines(lines, after)
      replaced = false

      ary = sexp.inject([]) do |acc, obj|
        if Sexp === obj && lines.include?(obj.line)
          if replaced
            acc
          else
            replaced = true
            acc + wrap(after)
          end
        else
          acc + [obj]
        end
      end

      Sexp.from_array(ary)
    end

    private

    def wrap(obj)
      if obj.is_a? Sexp
        [obj]
      elsif obj.is_a? Array
        obj
      else
        [obj]
      end
    end
  end
end
