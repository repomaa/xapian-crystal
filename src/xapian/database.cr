require "../glib/error"
require "../lib_xapian"

module Xapian
  class Database
    def self.new(path : String)
      db = Glib::Error.assert do |error|
        LibXapian.database_new_with_path(path, error)
      end

      new(db)
    end

    def initialize(@database : LibXapian::Database)
    end

    def doc_count
      LibXapian.database_get_doc_count(self)
    end

    def close
      LibXapian.database_close(self)
    end

    def reopen
      LibXapian.database_reopen(self)
    end

    def to_unsafe
      @database
    end
  end
end
