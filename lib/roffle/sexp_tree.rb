module Roffle
  class SexpTree
    attr_reader :sexp

    def initialize(sexp)
      @sexp = sexp
    end

    def all_with_type(type)
      matches = []

      if type == sexp.sexp_type
        matches << sexp
      end

      sexp.each_of_type(type) do |s|
        matches << s
      end

      matches
    end
  end
end
