require "./document"

module Xapian
  class Mset
    include Iterable({Document::Id, Document})
    include Enumerable({Document::Id, Document})

    def initialize(@mset : LibXapian::Mset)
    end

    def each
      Iterator.new(LibXapian.mset_get_begin(self))
    end

    def each
      each.each do |(id, document)|
        yield id, document
      end
    end

    def map(&block : (Document::Id, Document) -> T) forall T
      each.map do |(id, document)|
        block.call(id, document)
      end
    end

    def size
      LibXapian.mset_get_size(self)
    end

    def empty?
      Glib::Boolean.new(LibXapian.mset_is_empty(self)).true?
    end

    def to_unsafe
      @mset
    end

    class Iterator
      include ::Iterator({Document::Id, Document})

      def initialize(@iterator : LibXapian::MsetIterator)
      end

      def next
        has_next = Glib::Boolean.new(LibXapian.mset_iterator_next(self)).true?
        return stop unless has_next

        document = Glib::Error.assert do |error|
          Document.new(LibXapian.mset_iterator_get_document(self, error))
        end

        id = Glib::Error.assert do |error|
          LibXapian.mset_iterator_get_doc_id(self, error)
        end

        {id, document}
      end

      def to_unsafe
        @iterator
      end
    end
  end
end
