require 'turn/autorun'
require 'roffle'

def fixture_path(path)
  full_path = File.join('../../../fixtures', path)
  File.expand_path(full_path, __FILE__)
end

def file_to_sexp(path)
  parser = RubyParser.for_current_ruby
  parser.parse(File.read(path), path)
end

describe "Extract Method" do
  it "extracts methods with no local variables" do
    before = fixture_path('extract_method/before.rb')
    after  = fixture_path('extract_method/after.rb')

    source = Roffle::SourceLocation.new(before, 3..4)
    sexp = Roffle::ExtractMethod.apply(source, "print_details")
    sexp.must_equal file_to_sexp(after)
  end
end
