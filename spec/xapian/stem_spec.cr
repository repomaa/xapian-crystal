require "../spec_helper"

describe Xapian::Stem do
  describe ".available_languages" do
    it "returns a list of available languages" do
      Xapian::Stem.available_languages.should be_a(Array(String))
      Xapian::Stem.available_languages.should contain("english")
    end
  end

  describe ".new" do
    it "runs without raising" do
      Xapian::Stem.new
    end

    it "runs without raising with all available languages" do
      Xapian::Stem.available_languages.each do |lang|
        Xapian::Stem.new(lang)
      end
    end
  end
end
