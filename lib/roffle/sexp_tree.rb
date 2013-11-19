module Roffle
  class SexpTree
    attr_reader :sexp

    def initialize(sexp_or_array)
      @sexp = sexp_or_array
    end

    def all_with_type(type)
      matches = []

      if sexp.is_a? Sexp
        if type == sexp.sexp_type
          matches << sexp
        end

        sexp.each_of_type(type) do |s|
          matches << s
        end

        return matches
      else
        sexp.inject([]) do |memo, obj|
          memo + SexpTree.new(obj).all_with_type(type)
        end
      end
    end
  end
end
