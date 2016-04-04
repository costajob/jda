require "spec_helper"
require "jda/parser"

describe Jda::Parser do
  it "must raise an error for infalid JDA path" do
    -> { Jda::Parser::new(dir: "noent", filters: nil) }.must_raise Jda::Parser::InvalidFeedPath
  end
end
