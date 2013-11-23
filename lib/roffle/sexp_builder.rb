module Roffle
  module SexpBuilder
    # name: #to_sym
    # args: [Symbol | Sexp]
    # body: SexpTree | [Sexp]
    def self.method_def(name, args, body)
      s(:defn, name.to_sym, method_def_args(args), *body.to_a)
    end

    # args: [Symbol | Sexp]
    def self.method_def_args(args)
      s(:args, *args)
    end

    # name: #to_sym
    # args: [Sexp]
    def self.self_method_call(name, args = [])
      if args.empty?
        s(:call, nil, name.to_sym)
      else
        s(:call, nil, name.to_sym, *args)
      end
    end

    # name: #to_sym
    def self.local_variable(name)
      s(:lvar, name.to_sym)
    end
  end
end
