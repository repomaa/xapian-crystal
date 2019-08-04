require "../spec_helper"

describe Xapian::Enquire do
  describe ".new" do
    it "runs without throwing an error" do
      Xapian::Enquire.new(Xapian::WritableDatabase.create_or_open("test-db"))
    end
  end

  describe "#set_query" do
    subject = Xapian::Enquire.new(Xapian::WritableDatabase.create_or_open("test-db"))

    it "runs without throwing an error" do
      subject.set_query(Xapian::Query.new("test"))
    end
  end

  describe "#sort_by_value" do
    subject = Xapian::Enquire.new(Xapian::WritableDatabase.create_or_open("test-db"))

    it "runs without throwing an error" do
      subject.sort_by_value(1_u32)
    end
  end

  describe "#results" do
    subject = Xapian::Enquire.new(Xapian::WritableDatabase.create_or_open("test-db"))

    it "runs without throwing an error" do
      subject.results
    end
  end

  describe "searching" do
    db = Xapian::WritableDatabase.create_or_open("test-db")
    subject = Xapian::Enquire.new(db)

    it "returns all documents for a match all query" do
      5.times { db.add_document(Xapian::Document.new) }
      subject.set_query(Xapian::Query.match_all)
      subject.results.size.should eq(5)
    end

    describe Xapian::Mset do
      it "allows iterating over id document pairs" do
        5.times { db.add_document(Xapian::Document.new) }
        subject.set_query(Xapian::Query.match_all)
        results = subject.results
        results.should_not be_empty
        iterated = false

        results.each do |id, document|
          iterated = true
          id.should be_a(Xapian::Document::Id)
          document.should be_a(Xapian::Document)
        end

        iterated.should be_true
      end
    end
  end
end
