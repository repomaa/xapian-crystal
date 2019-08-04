# xapian-crystal [![Build Status](https://travis-ci.org/jreinert/xapian-crystal.svg?branch=master)](https://travis-ci.org/jreinert/xapian-crystal)

Xapian bindings for crystal

## Installation

1. install [xapian](http://xapian.org/)
2. Compile and install https://github.com/endlessm/xapian-glib
3. Add the following to your application's `shard.yml`:

```yaml
dependencies:
  xapian:
    github: repomaa/xapian-crystal
```

## Usage

### Indexing

```crystal
require "xapian"

db = Xapian::WritableDatabase.create_or_open("path/to/db")
term_generator = Xapian::TermGenerator.new(db, language: "english")

# Index a document
# Most of the following steps are optional

doc = Xapian::Document.new              # create a new document
doc.data = some_data.to_json            # add some data to display in results
date = Time.now.to_unix
doc.values[0] = date                    # add a value for sorting

# Add terms for document
term_generator.set_document(doc)
term_generator.index_text(title, "S")   # use predefined title prefix
term_generator.index_text(author, "A")  # use predefined author prefix
term_generator.index_text(body)         # don't use prefix for body

# Add the document to the database
db.add_document(doc)

# Repeat with as many documents as you like
# ...

# Commit changes
db.commit
```

### Searching

```crystal
require "xapian"

db = Xapian::Database.new("path/to/db")
query_parser = Xapian::QueryParser.new(db, language: "english")

# Set up the same prefixes as with the term generator
query_parser.add_prefix("title", "S")
query_parser.add_prefix("author", "A")

query = query_parser.parse("author:'Cormac McCarthy'")
enquire = Xapian::Enquire.new(db)
enquire.sort_by_value(0)    # sort by date
enquire.results.each do |id, document|
  puts({id, document.data})
end
```

## Contributing

1. Fork it ( https://github.com/repomaa/xapian/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [repomaa](https://github.com/repomaa) Joakim Repomaa - creator, maintainer
