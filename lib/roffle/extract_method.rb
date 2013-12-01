module Roffle
  class ExtractMethod
    def self.short_name
      'extract-method'
    end

    # sexp   - The SexpTree to apply the transformation to.
    # source - The SourceLocation of the input file.
    # name   - The String containing the name of the method to extract.
    #
    # Returns a SexpTree that has been refactored using Extract Method.
    def self.apply(sexp, source, name)
      new(sexp, source).apply(name)
    end

    attr_reader :source, :sexp

    def initialize(sexp, source)
      @sexp = sexp
      @source = source
    end

    # Public: Apply the Extract Method refactoring.
    #
    # name - An object that responds to #to_sym. Will be used as the name of
    #        the newly-extracted method.
    #
    # Returns a SexpTree that has been refactored using Extract Method.
    def apply(name)
      lines        = source.lines
      slice        = slice_sexp(lines)
      locals       = unbound_locals(slice)
      method_call  = method_call(name, locals)
      replaced     = replace_lines(lines, method_call)
      parent_scope = parent_scope(slice)
      method_defn  = method_defn(name, locals, slice)
      append_method_defn(parent_scope, replaced, method_defn)
    end

    private

    # line - Range
    # Returns [SexpTree].
    def slice_sexp(lines)
      source_map = SourceMap.new(sexp)
      source_map.at_lines(lines)
    end

    # slice - [SexpTree]
    # Returns [Symbol].
    def unbound_locals(slice)
      locals = slice.inject([]) do |memo, stree|
        memo + stree.all_of_type(:lvar)
      end

      # Unpack the name of each lvar: s(:lvar, :foo) -> :foo
      locals.uniq.map(&:to_sexp).map(&:last)
    end

    def replace_lines(lines, replacement)
      t = SexpTransformation.new(sexp)
      t.replace_lines(lines, replacement)
    end

    # name  - #to_sym
    # lvars - [Symbol]
    def method_call(name, lvars)
      # All arguments passed into our new method are local variables
      args = lvars.map { |var| SexpBuilder.local_variable(var) }
      SexpBuilder.self_method_call(name, args)
    end

    # XXX: Extract
    def parent_scope(slice)
      stree = slice.first # XXX: non-contiguous sexp

      while stree.parent
        stree = stree.parent

        if [:class, :module, :block].include? stree.sexp_type
          return stree
        end
      end

      # We've reached the end, and no suitable parent in sight,
      # so we make our own -- a :block sexp node
      SexpTree.new s(:block)
    end

    def method_defn(name, args, body)
      SexpBuilder.method_defn(name, args, body)
    end

    def append_method_defn(scope, stree, method_defn)
      SexpInjector.new(stree).append_method_defn(method_defn, scope)
    end
  end
end
