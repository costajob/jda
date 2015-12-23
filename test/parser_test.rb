require "test_helper"
require "jda/parser"

describe Jda::Parser do
  let(:parser) { Jda::Parser::new(files: %w[ebuswh.txt ebuseu.txt]) }

  it "must call CSV to read file" do
    parser.files.size.times { mock(Thread).new }
    parser.read_all
  end

  it "must set cache for read data" do
  end
end
