module Roffle
  class SourceMap
    def initialize(sexp)
      @sexp = sexp
      @map = build(sexp)
    end

    def at_lines(lines)
      lines.inject([]) do |acc, line|
        acc + wrap(@map[line])
      end
    end

    private

    def build(sexp)
      # wtb inject
      map = {}
      sexp.each_sexp do |s|
        map[s.line] ||= s
      end
      map
    end

    def wrap(obj)
      obj.nil? ? [] : [obj]
    end
  end
end
