module Glib
  struct Boolean
    def initialize(@value : LibGlib::Boolean)
    end

    def self.from_bool(value : Bool)
      new(value ? 1_u32 : 0_u32)
    end

    def false?
      @value == 0_u32
    end

    def true?
      !false?
    end

    def to_unsafe
      @value || 0_u32
    end
  end
end
