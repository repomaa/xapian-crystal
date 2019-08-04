require "./database"
require "../glib/boolean"
require "../glib/error"
require "./document"

module Xapian
  class WritableDatabase < Database
    CREATE_OR_OPEN = LibXapian::DatabaseAction::CREATE_OR_OPEN
    CREATE = LibXapian::DatabaseAction::CREATE
    CREATE_OR_OVERWRITE = LibXapian::DatabaseAction::CREATE_OR_OVERWRITE
    OPEN = LibXapian::DatabaseAction::OPEN

    def self.new(path, action)
      handler = Glib::Error.assert do |error|
        LibXapian.writable_database_new(path, action, error)
      end

      new(handler.as(LibXapian::Database))
    end

    def commit
      Glib::Error.assert do |error|
        LibXapian.writable_database_commit(as_writable, error)
      end
    end

    def transaction(flushed : Bool = true)
      begin_transaction(flushed)
      begin
        yield(self)
      rescue e
        cancel_transaction
        raise e
      end
      commit_transaction
    end

    def add_document(document : Document) : Document::Id
      Glib::Error.assert do |error|
        LibXapian.writable_database_add_document(as_writable, document, out id, error)

        id
      end
    end

    def replace_document(id : Document::Id, document : Document)
      Glib::Error.assert do |error|
        LibXapian.writable_database_replace_document(as_writable, id, document, error)
      end
    end

    def delete_document(id : Document::Id)
      Glib::Error.assert do |error|
        LibXapian.writable_database_delete_document(as_writable, id, error)
      end
    end

    def self.create(path)
      new(path, CREATE)
    end

    def self.create_or_open(path)
      new(path, CREATE_OR_OPEN)
    end

    def self.create_or_overwrite(path)
      new(path, CREATE_OR_OVERWRITE)
    end

    def self.open(path)
      new(path, OPEN)
    end

    def as_writable
      @database.as(LibXapian::WritableDatabase)
    end

    private def begin_transaction(flushed)
      Glib::Error.assert do |error|
        LibXapian.writable_database_begin_transaction(
          as_writable, Glib::Boolean.from_bool(flushed), error
        )
      end
    end

    private def cancel_transaction
      Glib::Error.assert do |error|
        LibXapian.writable_database_cancel_transaction(as_writable, error)
      end
    end

    private def commit_transaction
      Glib::Error.assert do |error|
        LibXapian.writable_database_commit_transaction(as_writable, error)
      end
    end
  end
end
