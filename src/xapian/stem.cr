require "../lib_xapian"

module Xapian
  class Stem
    class UnsupportedLanguageError < Exception
      def initialize(language)
        super("Language #{language} is not supported. Choose one of #{Stem.available_languages}")
      end
    end

    getter language

    @@available_languages : Array(String)?
    @stem : LibXapian::Stem

    def initialize(@language : String = "none")
      unless @language == "none" || self.class.available_languages.includes?(@language)
        raise UnsupportedLanguageError.new(@language)
      end

      @stem = Glib::Error.assert do |error|
        LibXapian.stem_new_for_language(@language, error)
      end
    end

    def to_unsafe
      @stem
    end

    def self.available_languages
      @@available_languages ||= query_available_languages
    end

    private def self.query_available_languages
      languages = LibXapian.stem_get_available_languages
      lang_count = LibGlib.strv_length(languages).to_i32
      Array.new(lang_count) do |index|
        String.new(languages[index])
      end
    end
  end
end
