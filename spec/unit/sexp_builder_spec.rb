require 'turn/autorun'
require 'sexp_processor'
require 'roffle/sexp_builder'

describe Roffle::SexpBuilder do
  describe ".method_defn" do
    it "returns a :defn sexp with 0 arity" do
      body = s(:call, nil, :puts, s(:str, "####"))
      sexp = Roffle::SexpBuilder.method_defn(:print_banner, [], [body])
      sexp.must_equal s(:defn, :print_banner, s(:args), body)
    end

    it "returns a :defn sexp with arguments" do
      body = s(:call, nil, :puts, s(:lvar, :amount))
      sexp = Roffle::SexpBuilder.method_defn(:print_details, [:outstanding], [body])
      sexp.must_equal s(:defn, :print_details, s(:args, :outstanding), body)
    end

    it "returns a :defn sexp with multi-line body" do
      body = [s(:call, nil, :puts, s(:lvar, :amount)), s(:call, nil, :puts, s(:ivar, :@name))]
      sexp = Roffle::SexpBuilder.method_defn(:print_details, [:amount], body)
      sexp.must_equal s(:defn, :print_details, s(:args, :amount), *body)
    end
  end

  describe ".self_method_call" do
    it "returns a :call sexp with 0 arity and implicit receiver" do
      sexp = Roffle::SexpBuilder.self_method_call(:print_banner)
      sexp.must_equal s(:call, nil, :print_banner)
    end

    it "returns a :call sexp with arguments and implicit receiver" do
      args = [s(:ivar, :@name), s(:lvar, :outstanding)]
      sexp = Roffle::SexpBuilder.self_method_call(:print_details, args)
      sexp.must_equal s(:call, nil, :print_details, *args)
    end
  end
end
