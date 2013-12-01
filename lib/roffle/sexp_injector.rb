module Roffle
  class SexpInjector
    attr_reader :stree

    def initialize(stree)
      @stree = stree
    end

    def append_method_defn(defn, scope)
      node = stree.depth_first.find { |n| n == scope }

      # scope is the parent of stree
      unless node
        sexp = scope.to_sexp
        sexp << stree.to_sexp
        sexp << defn
        return SexpTree.new(sexp)
      end

      parent = node.parent

      if parent
        sexp = scope.to_sexp
        sexp << defn
        appended = SexpTree.new(sexp, parent)
        replace(parent, scope, appended)
      else
        sexp = stree.to_sexp
        sexp << defn
        SexpTree.new(sexp)
      end
    end

    private

    def replace(parent, original, replace)
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
    # original - SexpTree
    # new      - SexpTree
    #
    # Returns a Sexp.
    def replace_in_sexp(sexp, original, new)
      sexp = sexp.to_sexp
      idx = sexp.index original.to_sexp
      sexp[idx] = new.to_sexp
      sexp
    end
  end
end
