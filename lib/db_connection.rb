require 'sqlite3'

PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'

ROOT_FOLDER = File.join(File.dirname(__FILE__), '..')
DB_SQL_FILE = File.join(ROOT_FOLDER, 'YOUR_SQL_SETUP_FILE_NAME_HERE')
DB_FILE = File.join(ROOT_FOLDER, 'YOUR_DB_FILE_NAME_HERE')
# DB_SQL_FILE = File.join(ROOT_FOLDER, 'movies_demo.sql')
# DB_FILE = File.join(ROOT_FOLDER, 'movies_demo.db')

class DBConnection

  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.reset
    commands = [
      "rm '#{DB_FILE}'",
      "cat '#{DB_SQL_FILE}' | sqlite3 '#{DB_FILE}'"
    ]

    commands.each { |command| `#{command}` }
    DBConnection.open(DB_FILE)
  end

  def self.instance
    open(DB_FILE) if @db.nil?

    @db
  end

  def self.execute(*args)
    instance.execute(*args)
  end

  def self.execute2(*args)
    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end
end
