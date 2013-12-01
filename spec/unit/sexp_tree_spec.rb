require 'turn/autorun'
require 'support/test_helpers'
require 'sexp_processor'
require 'roffle/sexp_tree'

describe Sexp do
  include TestHelpers

  describe "#to_sexp" do
    it "returns a copy of itself" do
      sexp = s(:call, nil, :puts, s(:lvar, :a))
      sexp.to_sexp.must_equal sexp
    end

    it "maintains line information" do
      foo = s(:call, nil, :foo)
      bar = s(:call, nil, :bar)
      baz = s(:call, nil, :baz)
      sexp = s(:block, foo, bar, baz)

      sexp = at_line(1) do
        s(:block,
          at_line(1) { s(:call, nil, :foo) },
          at_line(2) { s(:call, nil, :bar) },
          at_line(4) { s(:call, nil, :baz) })
      end

      out = sexp.to_sexp
      out.line.must_equal 1
      expected = [1, 2, 4]
      out.each_sexp { |node| node.line.must_equal expected.shift }
    end

    it "can convert SexpTree children back into Sexp" do
      sexp = s(:call, nil, :puts, st(:lvar, :a))
      sexp.to_sexp.must_equal s(:call, nil, :puts, s(:lvar, :a))
    end
  end
end

describe Roffle::SexpTree do
  include TestHelpers

  it "wraps a Sexp" do
    sexp = s(:call, nil, :puts)
    stree(sexp).to_sexp.must_equal sexp
  end

  it "wraps a SexpTree and converts it back as appropriate" do
    sexp = st(:call, nil, :puts, s(:call, nil, :foo, st(:str, "bar")))
    stree(sexp).to_sexp.must_equal s(:call, nil, :puts, s(:call, nil, :foo, s(:str, "bar")))
  end

  it "wraps child Sexp instances recursively" do
    lvar = s(:lvar, :foo)
    str  = s(:str, "foo")
    sexp = s(:call, lvar, :puts, str)
    stree(sexp).children.must_equal [stree(lvar), stree(str)]
  end

  it "returns the type of the top-level sexp" do
    sexp = s(:call, nil, :puts, s(:str, "foo"))
    stree(sexp).sexp_type.must_equal :call
  end

  it "holds a reference to its parent node" do
    sexp = s(:call, nil, :puts, s(:str, "foo"))
    child = stree(sexp).children.first
    child.parent.must_equal stree(sexp)
  end

  it "returns nil if there is no parent node" do
    sexp = s(:call, nil, :puts, s(:str, "foo"))
    stree(sexp).parent.must_be_nil
  end

  describe "#all_of_type" do
    it "returns an empty array when no matches are found" do
      sexp = s(:block, s(:lasgn, :a, s(:lit, 1.0)))
      stree(sexp).all_of_type(:lvar).must_be_empty
    end

    it "returns the top of the tree if it is a match" do
      sexp = s(:return, s(:lit, 2.0))
      stree(sexp).all_of_type(:return).must_equal [stree(sexp)]
    end

    it "returns all, arbitrarily-nested nodes matching the given type" do
      sexp = s(:block,
               s(:lasgn, :a, s(:lit, 1.0)),
               s(:lasgn, :b, s(:lvar, :a)),
               s(:call, nil, :puts, s(:call, nil, :foo, s(:lvar, :b))),
               s(:return, s(:lvar, :b)))
      matches = stree(sexp).all_of_type(:lvar)
      matches.must_equal [st(:lvar, :a), st(:lvar, :b), st(:lvar, :b)]
    end
  end
end
