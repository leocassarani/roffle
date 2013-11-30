module Roffle
  class SexpTree
    attr_reader :children

    def initialize(sexp)
      @sexp = sexp
      @children = wrap_children(sexp)
    end

    def sexp_type
      @sexp.sexp_type
    end

    def to_sexp
      @sexp
    end

    def ==(obj)
      obj.is_a?(self.class) && obj.to_sexp == to_sexp
    end

    def hash
      to_sexp.hash
    end

    def all_of_type(type)
      depth_first.select { |s| s.sexp_type == type }
    end

    # Public: Perform depth-first search on the receiver.
    #
    # Examples
    #
    #   sexp = s(:call, s(:call, s(:lvar, :a), :foo), :bar, s(:lvar, :baz))
    #   st(sexp).depth_first { |node| p node.to_sexp }
    #   # => s(:call, s(:call, (:lvar, :a), :foo), :bar, (:lvar, :baz))
    #   # => s(:call, (:lvar, :a), :foo)
    #   # => s(:lvar, :a)
    #   # => s(:lvar, :bar)
    #
    # Returns an Enumerator, or yields immediately if a block is given.
    def depth_first(&block)
      enum = Enumerator.new do |y|
        y.yield self

        children.each do |child|
          child.depth_first { |node| y.yield node }
        end
      end

      if block
        enum.each(&block)
      else
        enum
      end
    end

    private

    def wrap_children(sexp)
      sexp
        .select { |s| s.is_a? Sexp }
        .map { |s| wrap(s) }
    end

    def wrap(sexp)
      self.class.new(sexp)
    end
  end
end
