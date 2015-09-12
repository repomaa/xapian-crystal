require "../spec_helper"

describe Xapian::Query do
  describe ".new" do
    it "runs without errors" do
      query = Xapian::Query.new("foo")
      Xapian::Query.new(query.to_unsafe)
    end
  end

  describe ".match_all" do
    it "returns a query" do
      query = Xapian::Query.match_all
      query.should be_a(Xapian::Query)
    end
  end
end
