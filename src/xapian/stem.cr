module Xapian
  class Stem
    class UnsupportedLanguageError < Exception
      def initialize(language)
        super("Language #{language} is not supported. Choose one of #{Stem.available_languages}")
      end
    end

    getter language

    def initialize(@language = "none" : String)
      unless @language == "none" || self.class.available_languages.includes?(@language)
        raise UnsupportedLanguageError.new(@language)
      end

      Glib::Error.assert do |error|
        @stem = LibXapian.stem_new_for_language(@language, error)
      end
    end

    def to_unsafe
      @stem || Pointer(LibXapian::Stem).null
    end

    def self.available_languages
      @@available_languages ||= begin
        lang_count = available_languages_count
        languages = LibXapian.stem_get_available_languages
        languages.to_slice(lang_count).map do |lang_pointer|
          String.new(lang_pointer)
        end
      end
    end

    private def self.available_languages_count
      Int32.cast(LibGlib.strv_length(LibXapian.stem_get_available_languages))
    end
  end
end
