require "../spec_helper"

describe Xapian::TermGenerator do
  Spec.after_each do
    Dir["test-db/**"].sort_by { |path| -path.count("/") }.each do |path|
      File.delete(path)
    end
  end

  describe ".new" do
    it "runs without raising" do
      db = Xapian::WritableDatabase.create("test-db")
      Xapian::TermGenerator.new(db)
    end

    it "sets TermGeneratorFeature::NONE as flags if no options are given" do
      db = Xapian::WritableDatabase.create("test-db")
      term_generator = Xapian::TermGenerator.new(db)
      term_generator.flags.should eq(LibXapian::TermGeneratorFeature::NONE)
    end

    it "sets flags accordingly if options are given" do
      db = Xapian::WritableDatabase.create("test-db")
      term_generator = Xapian::TermGenerator.new(db, spelling: true)
      term_generator.flags.should eq(LibXapian::TermGeneratorFeature::SPELLING)
    end

    it "sets a stemmer accordingly if language option is set" do
      db = Xapian::WritableDatabase.create("test-db")
      term_generator = Xapian::TermGenerator.new(db, language: "english")
      term_generator.stem.should be_a(Xapian::Stem)
      term_generator.stem.language.should eq("english")
    end

    it "sets a stemmer accordingly if stemmer option is set" do
      db = Xapian::WritableDatabase.create("test-db")
      stem = Xapian::Stem.new("german")
      term_generator = Xapian::TermGenerator.new(db, stem: stem)
      term_generator.stem.should be_a(Xapian::Stem)
      term_generator.stem.language.should eq("german")
    end
  end

  describe "#set_document" do
    it "runs without raising" do
      db = Xapian::WritableDatabase.create("test-db")
      document = Xapian::Document.new
      Xapian::TermGenerator.new(db).set_document(document)
    end
  end

  describe "#index_text" do
    it "runs without raising" do
      db = Xapian::WritableDatabase.create("test-db")
      term_generator = Xapian::TermGenerator.new(db)
      term_generator.index_text("foobar")
      term_generator.index_text("foobar", "foo")
      term_generator.index_text("foobar", "foo", 1)
    end
  end
end
