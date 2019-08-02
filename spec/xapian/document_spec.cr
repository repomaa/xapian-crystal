require "../spec_helper"

describe Xapian::Document do
  describe ".new" do
    it "runs without throwing an error" do
      Xapian::Document.new
    end
  end

  describe "#data=" do
    it "sets the data for the document" do
      doc = Xapian::Document.new
      doc.data = "foobar"
      doc.data.should(eq("foobar"))
    end
  end

  describe "#data" do
    it "returns an empty String for new documents" do
      doc = Xapian::Document.new
      doc.data.should(eq(""))
    end
  end

  describe "#values" do
    describe "#[]=" do
      context "with string" do
        it "sets a value for the document" do
          doc = Xapian::Document.new
          doc.values[0_u32] = "foo"
          doc.values[0_u32].as_s.should(eq("foo"))
        end
      end

      context "with integer" do
        it "sets a value for the document" do
          doc = Xapian::Document.new
          doc.values[0_u32] = 42
          doc.values[0_u32].as_i.should(eq(42))
        end
      end

      context "with float" do
        it "sets a value for the document" do
          doc = Xapian::Document.new
          doc.values[0_u32] = 42.3
          doc.values[0_u32].as_f.should(eq(42.3))
        end
      end
    end

    describe "#count" do
      it "gives the count of values set for the document" do
        doc = Xapian::Document.new
        doc.values[0_u32] = "foo"
        doc.values.count.should(eq(1))
        doc.values[1_u32] = "foo"
        doc.values.count.should(eq(2))
      end
    end

    describe "#empty?" do
      it "returns true for new documents" do
        doc = Xapian::Document.new
        doc.values.empty?.should(be_true)
      end

      it "returns false as soon as there are any values set" do
        doc = Xapian::Document.new
        doc.values[0_u32] = "foo"
        doc.values.empty?.should(be_false)
      end
    end

    describe "#delete" do
    end
  end
end
