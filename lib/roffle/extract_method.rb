require_relative 'sexp_transformation'
require_relative 'sexp_tree'

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
      locals = unbound_locals(extracted)
      replacement = replace_with_method_call(lines, new_name, locals)
      new_method = method_definition(new_name, locals, extracted)

      s(:block, replacement, new_method)
    end

    private

    def sexp_slice(lines)
      source_map = SourceMap.new(sexp)
      source_map.at_lines(lines)
    end

    def unbound_locals(sexp)
      tree = SexpTree.new(sexp)
      tree.all_with_type(:lvar)
    end

    def replace_with_method_call(lines, method, locals)
      t = SexpTransformation.new(sexp)
      t.replace_lines(lines, method_call(method, locals))
    end

    def method_call(name, args)
      sexp = s(:call, nil, name)
      if args.any?
        sexp += args
      end
      Sexp.from_array(sexp)
    end

    def method_definition(name, args, body)
      args_sexp = Sexp.from_array([:args] + args.map(&:last))
      s(:defn, name, args_sexp, *body)
    end
  end
end
