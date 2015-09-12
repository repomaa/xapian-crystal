require "./database"
require "../glib/boolean"
require "./document"

module Xapian
  class WritableDatabase < Database
    CREATE_OR_OPEN = LibXapian::DatabaseAction::CREATE_OR_OPEN
    CREATE = LibXapian::DatabaseAction::CREATE
    CREATE_OR_OVERWRITE = LibXapian::DatabaseAction::CREATE_OR_OVERWRITE
    OPEN = LibXapian::DatabaseAction::OPEN

    def initialize(path, action)
      Glib::Error.assert do |error|
        @database = LibXapian.writable_database_new(path, action, error)
      end
    end

    def transaction(flushed = true : Bool)
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
        result = LibXapian.writable_database_add_document(self, document, out id, error)
        raise Exception.new("failed to add document") if Glib::Boolean.new(result).false?
        id
      end
    end

    def replace_document(id : Document::Id, document : Document)
      Glib::Error.assert do |error|
        result = LibXapian.writable_database_replace_document(self, id, document, error)
        raise Exception.new("failed to replace document") if Glib::Boolean.new(result).false?
      end
    end

    def delete_document(id : Document::Id)
      Glib::Error.assert do |error|
        result = LibXapian.writable_database_delete_document(self, id, error)
        raise Exception.new("failed to delete document") if Glib::Boolean.new(result).false?
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

    def to_unsafe
      @database || Pointer(LibXapian::WritableDatabase).null
    end

    private def begin_transaction(flushed)
      Glib::Error.assert do |error|
        result = LibXapian.writable_database_begin_transaction(self, Glib::Boolean.from_bool(flushed), error)
        raise Exception.new("failed to begin transaction") if Glib::Boolean.new(result).false?
      end
    end

    private def cancel_transaction
      Glib::Error.assert do |error|
        result = LibXapian.writable_database_cancel_transaction(self, error)
        raise Exception.new("failed to cancel transaction") if Glib::Boolean.new(result).false?
      end
    end

    private def commit_transaction
      Glib::Error.assert do |error|
        result = LibXapian.writable_database_commit_transaction(self, error)
        raise Exception.new("failed to cancel transaction") if Glib::Boolean.new(result).false?
      end
    end
  end
end
