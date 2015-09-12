require "../lib_xapian"
require "./stem"

module Xapian
  class TermGenerator
    getter flags, stem

    def initialize(database : WritableDatabase, spelling = false : Bool, stemmer = nil : Stem?, language = "none" : String)
      @term_generator = LibXapian.term_generator_new
      @flags = LibXapian::TermGeneratorFeature::NONE
      @stem = stemmer || Stem.new(language)
      @flags |= LibXapian::TermGeneratorFeature::SPELLING if spelling

      LibXapian.term_generator_set_database(self, database)
      LibXapian.term_generator_set_flags(self, @flags)
      LibXapian.term_generator_set_stemmer(self, @stem)
    end

    def set_document(document : Document)
      LibXapian.term_generator_set_document(self, document)
    end

    def index_text(data : String, prefix = nil : String?, wdf_increment = 1 : Int32)
      LibXapian.term_generator_index_text(self, data, UInt32.cast(wdf_increment), prefix)
    end

    def to_unsafe
      @term_generator || Pointer(LibXapian::TermGenerator).null
    end
  end
end
