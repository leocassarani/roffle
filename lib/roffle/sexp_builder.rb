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
  end
end
