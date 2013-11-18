require 'turn/autorun'
require 'sexp_processor'
require 'roffle/sexp_transformation'

describe Roffle::SexpTransformation do
  def at_line(line, &block)
    sexp = block.call
    sexp.line = line
    sexp
  end

  describe "#replace_lines" do
    it "replaces a single line with a single sexp" do
      body   = at_line(2) { s(:call, nil, :puts, s(:str, "####")) }
      method = at_line(1) { s(:defn, :print_owing, s(:args), body) }

      t = Roffle::SexpTransformation.new(method)
      sexp = t.replace_lines(2..2, s(:call, nil, :print_banner))

      sexp.must_equal s(:defn, :print_owing,
                        s(:args),
                        s(:call, nil, :print_banner))
    end

    it "replaces several lines with a single sexp" do
      one    = at_line(2) { s(:call, nil, :puts, s(:str, "####")) }
      two    = at_line(3) { s(:call, nil, :puts, s(:str, "====")) }
      method = at_line(1) { s(:defn, :print_owing, s(:args), one, two) }

      replacement = s(:call, nil, :print_banner)

      t = Roffle::SexpTransformation.new(method)
      sexp = t.replace_lines(2..3, replacement)

      sexp.must_equal s(:defn, :print_owing,
                        s(:args),
                        s(:call, nil, :print_banner))
    end

    it "replaces a single line with several sexps" do
      body   = at_line(2) { s(:call, nil, :puts, s(:str, "####")) }
      method = at_line(1) { s(:defn, :print_owing, s(:args), body) }

      replacement = [
        s(:call, nil, :print, s(:str, "####")),
        s(:call, nil, :print, s(:str, "\n"))
      ]

      t = Roffle::SexpTransformation.new(method)
      sexp = t.replace_lines(2..2, replacement)
      sexp.must_equal s(:defn, :print_owing,
                        s(:args),
                        s(:call, nil, :print, s(:str, "####")),
                        s(:call, nil, :print, s(:str, "\n")))
    end
  end
end
