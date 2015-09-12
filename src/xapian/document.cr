require "../lib_xapian"

module Xapian
  class Document
    alias Id = UInt32

    def initialize(document = nil)
      @document = document || LibXapian.document_new
    end

    def values : ValueSlots
      @values ||= ValueSlots.new(self)
    end

    def data=(data : String)
      LibXapian.document_set_data(self, data)
    end

    def data : String
      String.new(LibXapian.document_get_data(self))
    end

    def to_unsafe
      @document || Pointer(LibXapian::Document).null
    end

    class ValueSlots
      def initialize(document)
        @document = document
      end

      def [](slot : UInt32)
        String.new(LibXapian.document_get_value(@document, slot))
      end

      def []=(slot : UInt32, value : String)
        LibXapian.document_add_value(@document, slot, value)
      end

      def delete(slot : UInt32)
        LibXapian.document_remove_value(@document, slot)
      end

      def count
        LibXapian.document_get_values_count(@document)
      end

      def clear
        LibXapian.document_clear_values(@document)
      end

      def empty?
        count == 0_u32
      end
    end
  end
end
