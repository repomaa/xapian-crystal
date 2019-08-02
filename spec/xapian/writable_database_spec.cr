require "../spec_helper"

describe Xapian::WritableDatabase do
  Spec.after_each do
    Dir["test-db/**"].sort_by { |path| -path.count("/") }.each do |path|
      File.delete(path)
    end
  end

  describe ".create" do
    it "creates a database" do
      Xapian::WritableDatabase.create("test-db")
      Dir.exists?("test-db").should(be_true)
    end

    it "raises if it already exists" do
      Xapian::WritableDatabase.create("test-db")
      expect_raises(Glib::Error) do
        Xapian::WritableDatabase.create("test-db")
      end
    end
  end

  describe ".open" do
    it "opens an existing database" do
      db = Xapian::WritableDatabase.create("test-db")
      db.close
      Xapian::WritableDatabase.open("test-db")
    end

    pending "raises if database doesn't exist" do
      expect_raises(Glib::Error) do
        Xapian::WritableDatabase.open("test-db")
      end
    end
  end

  describe ".create_or_open" do
    it "creates a database" do
      Xapian::WritableDatabase.create_or_open("test-db")
      Dir.exists?("test-db").should(be_true)
    end

    it "opens an existing database" do
      db = Xapian::WritableDatabase.create_or_open("test-db")
      db.close
      Xapian::WritableDatabase.create_or_open("test-db")
    end
  end

  describe ".create_or_overwrite" do
    it "creates a database" do
      Xapian::WritableDatabase.create_or_overwrite("test-db")
      Dir.exists?("test-db").should(be_true)
    end

    it "overwrites an existing database" do
      db = Xapian::WritableDatabase.create_or_overwrite("test-db")
      db.close
      Xapian::WritableDatabase.create_or_overwrite("test-db")
    end
  end

  describe "#add_document" do
    it "runs without raising" do
      db = Xapian::WritableDatabase.create("test-db")
      doc = Xapian::Document.new
      db.add_document(doc)
    end

    it "returns the id of the added document" do
      db = Xapian::WritableDatabase.create("test-db")
      doc = Xapian::Document.new
      db.add_document(doc).should eq(1)
    end
  end

  describe "#replace_document" do
    it "runs without raising" do
      db = Xapian::WritableDatabase.create("test-db")
      doc = Xapian::Document.new
      db.replace_document(1_u32, doc)
    end
  end

  describe "#delete_document" do
    it "runs without raising" do
      db = Xapian::WritableDatabase.create("test-db")
      doc = Xapian::Document.new
      id = db.add_document(doc)
      db.delete_document(id)
    end

    it "raises an exception if trying to delete non existing document" do
      db = Xapian::WritableDatabase.create("test-db")
      expect_raises(Glib::Error) do
        db.delete_document(1_u32)
      end
    end
  end
end
