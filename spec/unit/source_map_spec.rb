require 'turn/autorun'
require 'sexp_processor'
require 'roffle/source_map'

describe Roffle::SourceMap do
  def at_line(line, &block)
    sexp = block.call
    sexp.line = line
    sexp
  end

  it "returns all sexps for a single line" do
    body = at_line(2) { s(:call, nil, :print_banner) }
    sexp = at_line(1) { s(:defn, :print_owing, s(:args), body) }
    map = Roffle::SourceMap.new(sexp)
    map.at_lines(2..2).must_equal [s(:call, nil, :print_banner)]
  end

  it "returns multiple sexps for several lines" do
    one  = at_line(2) { s(:call, nil, :print_banner) }
    two  = at_line(3) { s(:call, nil, :print_details) }
    sexp = at_line(1) { s(:defn, :print_owing, s(:args), one, two) }

    map = Roffle::SourceMap.new(sexp)
    map.at_lines(2..3).must_equal [
      s(:call, nil, :print_banner),
      s(:call, nil, :print_details)
    ]
  end
end
