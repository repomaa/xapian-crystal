require "../lib_xapian"

module Xapian
  class Enquire
    @enquire : LibXapian::Enquire

    def initialize(@db : Database)
      @enquire = Glib::Error.assert do |error|
        LibXapian.enquire_new(db, error)
      end
    end

    def set_query(query : Query, query_length : Int32 = 0)
      LibXapian.enquire_set_query(self, query, query_length.to_u32)
    end

    def sort_by_value(value : UInt32, reverse = false)
      LibXapian.enquire_set_sort_by_value(self, value, Glib::Boolean.from_bool(reverse))
    end

    def results(skip = 0, limit = @db.doc_count)
      Glib::Error.assert do |error|
        Mset.new(LibXapian.enquire_get_mset(self, skip, limit, error))
      end
    end

    def to_unsafe
      @enquire
    end
  end
end
