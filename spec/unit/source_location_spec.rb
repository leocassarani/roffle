require 'turn/autorun'
require 'roffle/source_location'

describe Roffle::SourceLocation do
  it "parses strings in the format filename:x" do
    source = Roffle::SourceLocation.from_string("lib/foo.rb:3")
    source.path.must_equal "lib/foo.rb"
    source.lines.must_equal (3..3)
  end

  it "parses strings in the format filename:x" do
    source = Roffle::SourceLocation.from_string("lib/foo.rb:3-6")
    source.path.must_equal "lib/foo.rb"
    source.lines.must_equal (3..6)
  end
end
