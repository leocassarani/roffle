module Roffle
  class SexpTransformation
    attr_reader :stree

    def initialize(stree)
      @stree = stree
      @source_map = SourceMap.new(stree)
    end

    # Public: Replace the given lines with the given sexp.
    #
    # lines       - The Range of lines to be replaced.
    # replacement - The SexpTree or [SexpTree] with which to replace
    #               the target lines.
    #
    # Returns a SexpTree with the given lines replaced.
    def replace_lines(lines, replacement)
      slice = @source_map.at_lines(lines)
      first = slice.first
      parent = first.parent

      raise "Can't replace top-level sexp yet" unless parent

      replacement = wrap(replacement)
      sexp = parent.to_sexp
      index = sexp.find_index first.to_sexp
      j = 0

      loop do
        s, r = slice[j], replacement[j]

        if s && r
          sexp[index + j] = r
        elsif s
          sexp.delete_at(index + j)
          # Compensate for the deletion
          index -= 1
        elsif r
          sexp.insert(index + j, r)
        else
          break
        end

        j += 1
      end

      replace(parent.parent, parent.to_sexp, sexp)
    end

    private

    # Returns a SexpTree.
    def replace(parent, original, replace)
      return SexpTree.new(replace) if parent.nil?

      grandparent = parent.parent
      sexp = replace_in_sexp(parent, original, replace)
      new_parent = SexpTree.new(sexp, grandparent)

      if grandparent
        replace(grandparent, parent, new_parent)
      else
        new_parent
      end
    end

    # sexp     - #to_sexp
    # original - #to_sexp
    # new      - #to_sexp
    #
    # Returns a Sexp.
    def replace_in_sexp(sexp, original, new)
      sexp = sexp.to_sexp
      idx = sexp.find_index original.to_sexp
      sexp[idx] = new.to_sexp
      sexp
    end

    def wrap(obj)
      case obj
      when SexpTree
        [obj]
      when Array
        obj
      else
        [obj]
      end
    end
  end
end
