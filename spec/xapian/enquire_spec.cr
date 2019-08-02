require "../spec_helper"

describe Xapian::Enquire do
  describe ".new" do
    it "runs without throwing an error" do
      Xapian::Enquire.new(Xapian::WritableDatabase.create_or_open("test-db"))
    end
  end
end
