@[Link("glib-2.0")]

lib LibGlib
  struct Error
    domain : UInt32
    code : Int32
    message : UInt8*
  end

  type Boolean = UInt32
  fun strv_length = g_strv_length(strings : UInt8**) : UInt32
  fun error_free = g_error_free(error : Error*) : Void
end
