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
      extracted   = slice_sexp(lines)
      locals      = unbound_locals(extracted)
      replacement = replace_with_method_call(lines, name, locals)
      new_method  = method_definition(name, locals, extracted)

      s(:block, replacement, new_method)
    end

    private

    def slice_sexp(lines)
      source_map = SourceMap.new(sexp)
      source_map.at_lines(lines)
    end

    def unbound_locals(sexp)
      tree = SexpTree.new(sexp)
      lvars = tree.all_with_type(:lvar)
      # Unpack the name of each lvar: s(:lvar, :foo) -> :foo
      lvars.map(&:last)
    end

    def replace_with_method_call(lines, method, locals)
      t = SexpTransformation.new(sexp)
      t.replace_lines(lines, method_call(method, locals))
    end

    # name: #to_sym
    # lvars: [Symbol]
    def method_call(name, lvars)
      # All arguments passed into our new method are local variables
      args = lvars.map { |var| SexpBuilder.local_variable(var) }
      SexpBuilder.self_method_call(name, args)
    end

    def method_definition(name, args, body)
      SexpBuilder.method_def(name, args, body)
    end
  end
end
