module TestHelpers
  def at_line(line, &block)
    sexp = block.call
    sexp.line = line
    sexp
  end

  def stree(sexp)
    Roffle::SexpTree.new(sexp)
  end
end
