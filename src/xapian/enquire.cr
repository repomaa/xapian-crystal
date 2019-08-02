module Xapian
  class Enquire
    @enquire : LibXapian::Enquire

    def initialize(db)
      @enquire = Glib::Error.assert do |error|
        LibXapian.enquire_new(db, error)
      end
    end
  end
end
