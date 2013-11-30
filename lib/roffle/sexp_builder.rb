module Roffle
  module SexpBuilder
    # name - #to_sym
    # args - [Symbol | Sexp]
    # body - [SexpTree]
    def self.method_defn(name, args, body)
      st(:defn, name.to_sym, method_defn_args(args), *body.to_a)
    end

    # args - [Symbol | SexpTree]
    def self.method_defn_args(args)
      st(:args, *args)
    end

    # name - #to_sym
    # args - [SexpTree]
    def self.self_method_call(name, args = [])
      if args.empty?
        st(:call, nil, name.to_sym)
      else
        st(:call, nil, name.to_sym, *args)
      end
    end

    # name - #to_sym
    def self.local_variable(name)
      st(:lvar, name.to_sym)
    end
  end
end
