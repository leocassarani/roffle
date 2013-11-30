module Roffle
  class ExtractMethod
    def self.short_name
      'extract-method'
    end

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
    # Returns a Sexp that has been refactored using Extract Method.
    def apply(name)
      lines       = source.lines
      slice       = slice_sexp(lines)
      locals      = unbound_locals(slice)
      method_call = method_call(name, locals)
      replacement = replace_lines(lines, method_call)
      method_defn = method_defn(name, locals, slice)
      concat(replacement, method_defn)
    end

    private

    def slice_sexp(lines)
      source_map = SourceMap.new(sexp)
      source_map.at_lines(lines)
    end

    def unbound_locals(slice)
      locals = slice.inject([]) do |memo, sexp|
        tree = SexpTree.new(sexp)
        memo + tree.all_of_type(:lvar)
      end

      # Unpack the name of each lvar: s(:lvar, :foo) -> :foo
      locals.uniq.map(&:to_sexp).map(&:last)
    end

    def replace_lines(lines, replacement)
      t = SexpTransformation.new(sexp)
      t.replace_lines(lines, replacement)
    end

    # name: #to_sym
    # lvars: [Symbol]
    def method_call(name, lvars)
      # All arguments passed into our new method are local variables
      args = lvars.map { |var| SexpBuilder.local_variable(var) }
      SexpBuilder.self_method_call(name, args)
    end

    def method_defn(name, args, body)
      SexpBuilder.method_defn(name, args, body)
    end

    def concat(first, second)
      s(:block, first, second)
    end
  end
end
