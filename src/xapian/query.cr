require "../lib_xapian"

module Xapian
  class Query
    alias Op = LibXapian::QueryOp

    def self.new(query : Query)
      new(query.to_unsafe)
    end

    def self.new(term : String)
      new(LibXapian.query_new_for_term(term))
    end

    def self.match_all
      new(LibXapian.query_new_match_all)
    end

    def initialize(@query : LibXapian::Query)
    end

    def join(op : Op, other : Query)
      self.class.new(LibXapian.query_new_for_pair(op, self, other))
    end

    def empty?
      result = LibXapian.query_is_empty(self)
      Glib::Boolean.new(result).true?
    end

    def length
      LibXapian.query_get_length(self).to_i
    end

    def description
      String.new(LibXapian.query_get_description(self))
    end

    def serialize
      String.new(LibXapian.query_serialise(self))
    end

    def to_unsafe
      @query
    end
  end
end
