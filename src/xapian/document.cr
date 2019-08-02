require "../lib_xapian"

module Xapian
  class Document
    alias Id = UInt32

    @document : LibXapian::Document
    @values : ValueSlots

    getter :values

    def initialize(@document = LibXapian.document_new)
      @values = ValueSlots.new(@document)
    end

    def data=(data : String)
      LibXapian.document_set_data(self, data)
    end

    def data : String
      String.new(LibXapian.document_get_data(self))
    end

    def to_unsafe
      @document
    end

    class ValueSlots
      struct Value
        def initialize(@string_value : UInt8*)
        end

        def self.new(value : String)
          new(value.to_unsafe)
        end

        def self.new(value : Int32)
          new(value.to_f)
        end

        def self.new(value : Int64)
          new(value.to_f)
        end

        def self.new(value : Float64)
          pointer = LibXapian.sortable_serialise(value, out length)
          new(String.new(pointer, length))
        end

        def as_s
          String.new(@string_value)
        end

        def as_i
          as_f.to_i
        end

        def as_i64
          as_f.to_i64
        end

        def as_f
          LibXapian.sortable_unserialise(@string_value, as_s.bytesize)
        end

        def to_unsafe
          @string_value
        end
      end

      def initialize(@document : LibXapian::Document)
      end

      def [](slot : UInt32)
        Value.new(LibXapian.document_get_value(@document, slot))
      end

      def []=(slot : UInt32, value : Value)
        LibXapian.document_add_value(@document, slot, value)
      end

      def []=(slot : UInt32, value)
        self[slot] = Value.new(value)
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
