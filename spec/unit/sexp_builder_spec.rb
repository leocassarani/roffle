require 'turn/autorun'
require 'sexp_processor'
require 'roffle/sexp_builder'

describe Roffle::SexpBuilder do
  describe ".method_def" do
    it "returns a :defn sexp with 0 arity" do
      body = s(:call, nil, :puts, s(:str, "####"))
      sexp = Roffle::SexpBuilder.method_def(:print_banner, [], [body])
      sexp.must_equal s(:defn, :print_banner, s(:args), body)
    end

    it "returns a :defn sexp with arguments" do
      body = s(:call, nil, :puts, s(:lvar, :amount))
      sexp = Roffle::SexpBuilder.method_def(:print_details, [:outstanding], [body])
      sexp.must_equal s(:defn, :print_details, s(:args, :outstanding), body)
    end

    it "returns a :defn sexp with multi-line body" do
      body = [s(:call, nil, :puts, s(:lvar, :amount)), s(:call, nil, :puts, s(:ivar, :@name))]
      sexp = Roffle::SexpBuilder.method_def(:print_details, [:amount], body)
      sexp.must_equal s(:defn, :print_details, s(:args, :amount), *body)
    end
  end
end
