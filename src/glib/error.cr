module Glib
  class Error < Exception
    def self.assert(&block)
      error = Pointer(LibGlib::Error).null
      result = yield(pointerof(error))
      raise new(String.new(error.value.message)) unless error.null?
      result
    end
  end
end
