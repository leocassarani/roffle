module Roffle
  class SourceMap
    def initialize(stree)
      @map = build(stree)
    end

    def at_lines(lines)
      lines.inject([]) do |acc, line|
        acc + wrap(@map[line])
      end
    end

    private

    def build(stree)
      stree.depth_first.inject({}) do |memo, node|
        memo[node.line] ||= node
        memo
      end
    end

    def wrap(obj)
      obj.nil? ? [] : [obj]
    end
  end
end
