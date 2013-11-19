require 'turn/autorun'
require 'sexp_processor'
require 'roffle/sexp_tree'

describe Roffle::SexpTree do
  describe "#all_of_type" do
    it "returns an empty array when no matches are found" do
      sexp = s(:block, s(:lasgn, :a, s(:lit, 1.0)))
      tree = Roffle::SexpTree.new(sexp)
      tree.all_with_type(:lvar).must_be_empty
    end

    it "returns the top of the tree if it is a match" do
      sexp = s(:return, s(:lit, 2.0))
      tree = Roffle::SexpTree.new(sexp)
      tree.all_with_type(:return).must_equal [sexp]
    end

    it "returns all nodes matching the given type" do
      sexp = s(:block,
               s(:lasgn, :a, s(:lit, 1.0)),
               s(:lasgn, :b, s(:lvar, :a)),
               s(:return, s(:lvar, :b)))
      tree = Roffle::SexpTree.new(sexp)
      matches = tree.all_with_type(:lvar)
      matches.must_equal [s(:lvar, :a), s(:lvar, :b)]
    end
  end
end
