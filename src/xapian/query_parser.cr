module Xapian
  class QueryParser
    def initialize(database : Database, stemmer = nil : Stem?, language = "none" : String, @default_prefix = "" : String)
      @parser = LibXapian.query_parser_new
      @stem = stemmer || Stem.new(language)
      @flags = LibXapian::QueryParserFeature::DEFAULT
      LibXapian.query_parser_set_database(self,database)
      LibXapian.query_parser_set_stemmer(self, @stem)
    end

    def add_prefix(field : String, prefix : String)
      LibXapian.query_parser_add_prefix(self, field, prefix)
    end

    def add_boolean_prefix(field : String, prefix : String, exclusive = true : Bool)
      LibXapian.query_parser_add_boolean_prefix(self, field, prefix, Glib::Boolean.from_bool(exclusive))
    end

    def parse(query_string : String) : Query
      Glib::Error.assert do |error|
        Query.new(LibXapian.query_parser_parse_query(self, query_string, @flags, @default_prefix, error))
      end
    end

    def to_unsafe
      @parser || Pointer(LibXapian::QueryParser).null
    end
  end
end
