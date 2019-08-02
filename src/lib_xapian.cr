require "./lib_glib.cr"
@[Link("xapian-glib-1.0")]

lib LibXapian
  enum DatabaseAction
    CREATE_OR_OPEN = 0
    CREATE_OR_OVERWRITE = 1
    CREATE = 2
    OPEN = 3
  end

  enum Error
    ASSERTION
    INVALID_ARGUMENT
    INVALID_OPERATION
    UNIMPLEMENTED
    DATABASE
    DATABASE_CORRUPT
    DATABASE_CREATE
    DATABASE_LOCK
    DATABASE_MODIFIED
    DATABASE_OPENING
    DATABASE_VERSION
    DOC_NOT_FOUND
    FEATURE_UNAVAILABLE
    INTERNAL
    NETWORK
    NETWORK_TIMEOUT
    QUERY_PARSER
    SERIALISATION
    RANGE
    LAST
  end

  enum TermGeneratorFeature
    NONE
    SPELLING = 1
  end

  enum QueryParserFeature
    BOOLEAN = 1 << 0
    PHRASE = 1 << 1
    LOVEHATE = 1 << 2
    BOOLEAN_ANY_CASE = 1 << 3
    WILDCARD = 1 << 4
    PURE_NOT = 1 << 5
    PARTIAL = 1 << 6
    SPELLING_CORRECTION = 1 << 7
    SYNONYM = 1 << 8
    AUTO_SYNONYMS = 1 << 9
    MULTIWORD_SYNONYMS = 1 << 10 | AUTO_SYNONYMS
    DEFAULT = BOOLEAN | PHRASE | LOVEHATE
  end

  enum QueryOp
    AND
    OR
    AND_NOT
    XOR
    AND_MAYBE
    FILTER
    NEAR
    PHRASE
    VALUE_RANGE
    SCALE_WEIGHT
    ELITE_SET
    VALUE_GE
    VALUE_LE
    SYNONYM
  end

  type Database = Void*
  type WritableDatabase = Void*
  type TermGenerator = Void*
  type Stem = Void*
  type Document = Void*
  type QueryParser = Void*
  type Query = Void*
  type Enquire = Void*

  fun database_new_with_path = xapian_database_new_with_path(path : UInt8*) : Database
  fun writable_database_new = xapian_writable_database_new(path : UInt8*, action : DatabaseAction, error : LibGlib::Error**) : WritableDatabase
  fun writable_database_add_document = xapian_writable_database_add_document(database : WritableDatabase, document : Document, id_out : UInt32*, error : LibGlib::Error**) : LibGlib::Boolean
  fun writable_database_delete_document = xapian_writable_database_delete_document(database : WritableDatabase, id : UInt32, error : LibGlib::Error**) : LibGlib::Boolean
  fun writable_database_replace_document = xapian_writable_database_replace_document(database : WritableDatabase, id : UInt32, document : Document, error : LibGlib::Error**) : LibGlib::Boolean
  fun writable_database_begin_transaction = xapian_writable_database_begin_transaction(database : WritableDatabase, flushed : LibGlib::Boolean, error : LibGlib::Error**) : LibGlib::Boolean
  fun writable_database_cancel_transaction = xapian_writable_database_cancel_transaction(database : WritableDatabase, error : LibGlib::Error**) : LibGlib::Boolean
  fun writable_database_commit_transaction = xapian_writable_database_commit_transaction(database : WritableDatabase, error : LibGlib::Error**) : LibGlib::Boolean
  fun database_close = xapian_database_close(database : Database)
  fun database_reopen = xapian_database_reopen(database : Database)

  fun document_new = xapian_document_new : Document
  fun document_get_value = xapian_document_get_value(document : Document, slot : UInt32) : UInt8*
  fun document_add_value = xapian_document_add_value(document : Document, slot : UInt32, value : UInt8*)
  fun document_remove_value = xapian_document_remove_value(document : Document, slot : UInt32)
  fun document_clear_values = xapian_document_clear_values(document : Document)
  fun document_get_values_count = xapian_document_get_values_count(document : Document) : UInt32
  fun document_get_data = xapian_document_get_data(document : Document) : UInt8*
  fun document_set_data = xapian_document_set_data(document : Document, data : UInt8*)

  fun term_generator_new  = xapian_term_generator_new : TermGenerator
  fun term_generator_set_database = xapian_term_generator_set_database(term_generator : TermGenerator, database : WritableDatabase)
  fun term_generator_set_flags = xapian_term_generator_set_flags(term_generator : TermGenerator, flags : TermGeneratorFeature)
  fun term_generator_set_stemmer = xapian_term_generator_set_stemmer(term_generator : TermGenerator, stemmer : Stem)
  fun term_generator_set_document = xapian_term_generator_set_document(term_generator : TermGenerator, document : Document)
  fun term_generator_index_text = xapian_term_generator_index_text(term_generator : TermGenerator, data : UInt8*, wdf_inc : UInt32, prefix : UInt8*)

  fun stem_new_for_language = xapian_stem_new_for_language(language : UInt8*, error : LibGlib::Error**) : Stem
  fun stem_get_available_languages = xapian_stem_get_available_languages : UInt8**

  fun query_parser_new = xapian_query_parser_new : QueryParser
  fun query_parser_set_stemmer = xapian_query_parser_set_stemmer(parser : QueryParser, stemmer : Stem)
  fun query_parser_set_database = xapian_query_parser_set_database(parser : QueryParser, database : Database)
  fun query_parser_add_prefix = xapian_query_parser_add_prefix(parser : QueryParser, field : UInt8*, prefix : UInt8*)
  fun query_parser_add_boolean_prefix = xapian_query_parser_add_boolean_prefix(parser : QueryParser, field : UInt8*, prefix : UInt8*, exclusive : LibGlib::Boolean)
  fun query_parser_parse_query = xapian_query_parser_parse_query_full(parser : QueryParser, query_string : UInt8*, flags : QueryParserFeature, default_prefix : UInt8*, error : LibGlib::Error**)

  fun query_new_for_term = xapian_query_new_for_term(term : UInt8*) : Query
  fun query_new_for_pair = xapian_query_new_for_pair(op : QueryOp, a : Query, b : Query) : Query
  fun query_new_match_all = xapian_query_new_match_all : Query
  fun query_is_empty = xapian_query_is_empty(query : Query) : LibGlib::Boolean
  fun query_get_length = xapian_query_get_length(query : Query) : UInt32
  fun query_get_description = xapian_query_get_description(query : Query) : UInt8*
  fun query_serialize = xapian_query_serialize(query : Query) : UInt8*

  fun enquire_new = xapian_enquire_new(db : Database, error : LibGlib::Error**) : Enquire

  fun sortable_serialise = xapian_sortable_serialise(value : Float64, length_ptr : UInt64*) : UInt8*
  fun sortable_unserialise = xapian_sortable_unserialise(value : UInt8*, length : UInt64) : Float64
end
