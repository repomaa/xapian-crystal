require "../lib_xapian"
require "../glib/error"

module Xapian
  class Database
    def initialize(path : String)
      Glib::Error.assert do |error|
        @database = LibXapian.database_new_with_path(path, error)
      end
    end

    def close
      LibXapian.database_close(to_database)
    end

    def reopen
      LibXapian.database_reopen(to_database)
    end

    def to_unsafe
      (@database || Pointer(LibXapian::Database).null) as Pointer(LibXapian::Database)
    end

    protected def to_database
      to_unsafe as Pointer(LibXapian::Database)
    end
  end
end
