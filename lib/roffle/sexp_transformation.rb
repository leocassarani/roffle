module Roffle
  class SexpTransformation
    attr_reader :stree

    def initialize(stree)
      @stree = stree
    end

    def replace_lines(lines, after)
      replaced = false

      ary = stree.to_sexp.inject([]) do |acc, obj|
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

      SexpTree.new Sexp.from_array(ary)
    end

    private

    def wrap(obj)
      case obj
      when SexpTree
        [obj.to_sexp]
      when Array
        obj.map(&:to_sexp)
      else
        [obj]
      end
    end
  end
end
