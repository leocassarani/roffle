class Sexp
  def to_sexp
    ary = inject([]) do |memo, node|
      if node.respond_to?(:to_sexp)
        memo + [node.to_sexp]
      else
        memo + [node]
      end
    end

    sexp = s(*ary)
    sexp.line = line
    sexp
  end
end

module Roffle
  class SexpTree
    attr_reader :children, :line

    def initialize(sexp)
      @sexp = sexp.to_sexp
      @children = wrap_children(@sexp)
    end

    def to_sexp
      @sexp
    end

    def to_a
      to_sexp.to_a
    end

    def sexp_type
      to_sexp.sexp_type
    end

    def line
      to_sexp.line
    end

    def ==(obj)
      obj.respond_to?(:to_sexp) && obj.to_sexp == to_sexp
    end

    def hash
      to_sexp.hash
    end

    def inspect
      to_sexp.inspect
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
        .select { |s| Sexp === s || self.class === s }
        .map { |s| wrap(s) }
    end

    def wrap(sexp)
      case sexp
      when Sexp
        self.class.new(sexp)
      else
        sexp
      end
    end
  end
end

module Kernel
  def st(*args)
    Roffle::SexpTree.new(s(*args))
  end
end
