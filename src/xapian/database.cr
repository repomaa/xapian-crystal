require "../glib/error"
require "../lib_xapian"

module Xapian
  class Database
    def self.new(path : String)
      db = LibXapian.database_new_with_path(path)
      new(db)
    end

    def initialize(@database : LibXapian::Database)
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
