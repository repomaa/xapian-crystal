require "file_utils"
require "spec"
require "../src/xapian"

Spec.after_each do
  FileUtils.rm_r("test-db") if Dir.exists?("test-db")
end
