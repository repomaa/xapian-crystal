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
    it "returns all documents for a match all query" do
      db = Xapian::WritableDatabase.create_or_open("test-db")
      5.times { db.add_document(Xapian::Document.new) }
      db.commit
      db.close

      ro_db = Xapian::Database.new("test-db")

      subject = Xapian::Enquire.new(ro_db)
      subject.set_query(Xapian::Query.match_all)

      subject.results.size.should eq(5)
    end

    describe Xapian::Mset do
      it "allows iterating over id document pairs" do
        db = Xapian::WritableDatabase.create_or_open("test-db")

        inserted_docs = Array.new(5) do
          doc = Xapian::Document.new
          doc.data = "test"
          doc.values[0] = 5

          {id: db.add_document(doc), data: doc.data, value: doc.values[0].as_i}
        end

        db.commit
        db.close

        ro_db = Xapian::Database.new("test-db")

        subject = Xapian::Enquire.new(ro_db)
        subject.set_query(Xapian::Query.match_all)

        results = subject.results
        results.should_not be_empty

        queried_docs = results.map do |id, doc|
          {id: id, data: doc.data, value: doc.values[0].as_i}
        end

        queried_docs.should eq(inserted_docs)
      end
    end
  end
end
