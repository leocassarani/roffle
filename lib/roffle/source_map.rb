module Roffle
  class SourceMap
    def initialize(sexp)
      @sexp = sexp
      @map = build(sexp)
    end

    def at_lines(lines)
      lines.inject([]) { |acc, line| acc + @map[line] }
    end

    private

    def build(sexp)
      # wtb inject
      map = Hash.new { |h, k| h[k] = [] }
      sexp.each_sexp do |s|
        map[s.line] << s
      end
      map
    end
  end
end
