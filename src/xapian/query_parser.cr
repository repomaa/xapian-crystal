module Xapian
  class QueryParser
    def initialize(database : Database, language : String = "none", @stem : Stem = Stem.new(language), @default_prefix : String = "")
      @parser = LibXapian.query_parser_new
      @flags = LibXapian::QueryParserFeature::DEFAULT
      LibXapian.query_parser_set_database(self,database)
      LibXapian.query_parser_set_stemmer(self, @stem)
    end

    def add_prefix(field : String, prefix : String)
      LibXapian.query_parser_add_prefix(self, field, prefix)
    end

    def add_boolean_prefix(field : String, prefix : String, exclusive : Bool = true)
      LibXapian.query_parser_add_boolean_prefix(self, field, prefix, Glib::Boolean.from_bool(exclusive))
    end

    def parse(query_string : String) : Query
      Glib::Error.assert do |error|
        Query.new(LibXapian.query_parser_parse_query(self, query_string, @flags, @default_prefix, error))
      end
    end

    def to_unsafe
      @parser || Pointer(Void).null.as(LibXapian::QueryParser)
    end
  end
end
