module Roffle
  class SexpTree
    attr_reader :sexp

    def initialize(sexp_or_array)
      @sexp = sexp_or_array
    end

    def search(opts = {})
      type = opts.fetch(:type)
      matches = []

      if sexp.is_a? Sexp
        sexp.each_of_type(type) do |s|
          matches << s
        end
        return matches
      else
        sexp.inject([]) do |memo, obj|
          memo + SexpTree.new(obj).search(opts)
        end
      end
    end
  end
end
