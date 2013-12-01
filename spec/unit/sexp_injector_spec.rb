require 'turn/autorun'
require 'sexp_processor'
require 'roffle/sexp_tree'
require 'roffle/sexp_injector'

describe Roffle::SexpInjector do
  describe "#append_method_defn" do
    it "appends the method to the top-level node" do
      stree = st(:class, :Receipt, nil,
                st(:defn, :print_owing,
                   st(:args),
                   st(:call, nil, :print_banner),
                   st(:call, nil, :puts, st(:lit, 0.0))))

      defn = st(:defn, :print_banner,
                st(:args),
                st(:call, nil, :puts, st(:str, "***")))

      expected = st(:class, :Receipt, nil,
                    st(:defn, :print_owing,
                       st(:args),
                       st(:call, nil, :print_banner),
                       st(:call, nil, :puts, st(:lit, 0.0))),
                     st(:defn, :print_banner,
                       st(:args),
                       st(:call, nil, :puts, st(:str, "***"))))

      injector = Roffle::SexpInjector.new(stree)
      injector.append_method_defn(defn, stree).must_equal expected
    end

    it "appends the method to a child of the top-level node" do
      stree = st(:module, :Refactoring,
                st(:class, :Receipt, nil,
                  st(:defn, :print_owing,
                     st(:args),
                     st(:call, nil, :print_banner),
                     st(:call, nil, :puts, st(:lit, 0.0)))))

      klass = stree.all_of_type(:class).first

      defn = st(:defn, :print_banner,
                st(:args),
                st(:call, nil, :puts, st(:str, "***")))

      expected = st(:module, :Refactoring,
                    st(:class, :Receipt, nil,
                      st(:defn, :print_owing,
                         st(:args),
                         st(:call, nil, :print_banner),
                         st(:call, nil, :puts, st(:lit, 0.0))),
                       st(:defn, :print_banner,
                         st(:args),
                         st(:call, nil, :puts, st(:str, "***")))))

      injector = Roffle::SexpInjector.new(stree)
      injector.append_method_defn(defn, klass).must_equal expected
    end
  end
end
