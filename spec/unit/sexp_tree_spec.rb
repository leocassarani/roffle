require 'turn/autorun'
require 'sexp_processor'
require 'roffle/sexp_tree'

describe Roffle::SexpTree do
  def st(sexp)
    Roffle::SexpTree.new(sexp)
  end

  def sts(*args)
    st(s(*args))
  end

  it "wraps a Sexp" do
    sexp = s(:call, nil, :puts)
    st(sexp).to_sexp.must_equal sexp
  end

  it "wraps child Sexp instances recursively" do
    lvar = s(:lvar, :foo)
    str  = s(:str, "foo")
    sexp = s(:call, lvar, :puts, str)
    st(sexp).children.must_equal [st(lvar), st(str)]
  end

  it "returns the type of the top-level sexp" do
    sexp = s(:call, nil, :puts, s(:str, "foo"))
    st(sexp).sexp_type.must_equal :call
  end

  describe "#all_of_type" do
    it "returns an empty array when no matches are found" do
      sexp = s(:block, s(:lasgn, :a, s(:lit, 1.0)))
      st(sexp).all_of_type(:lvar).must_be_empty
    end

    it "returns the top of the tree if it is a match" do
      sexp = s(:return, s(:lit, 2.0))
      st(sexp).all_of_type(:return).must_equal [st(sexp)]
    end

    it "returns all, arbitrarily-nested nodes matching the given type" do
      sexp = s(:block,
               s(:lasgn, :a, s(:lit, 1.0)),
               s(:lasgn, :b, s(:lvar, :a)),
               s(:call, nil, :puts, s(:call, nil, :foo, s(:lvar, :b))),
               s(:return, s(:lvar, :b)))
      matches = st(sexp).all_of_type(:lvar)
      matches.must_equal [sts(:lvar, :a), sts(:lvar, :b), sts(:lvar, :b)]
    end
  end
end
