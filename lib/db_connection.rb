require 'sqlite3'

PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'

#Replace the sample.sql and sample.db file names with names of your own files in the root folder.
ROOT_FOLDER = File.join(File.dirname(__FILE__), '..')
DB_SQL_FILE = File.join(ROOT_FOLDER, 'YOUR_SQL_SETUP_FILE_NAME_HERE')
DB_FILE = File.join(ROOT_FOLDER, 'YOUR_DB_FILE_NAME_HERE')

class DBConnection

  # Crate a new SQLite databse in the root folder.and returns a reference to it.
  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  #Runs shell commands to remove the databse and recreate it populated from the SQL file.
  #Reopens the databse and returns a reference to it.
  def self.reset
    commands = [
      "rm '#{DB_FILE}'",
      "cat '#{DB_SQL_FILE}' | sqlite3 '#{DB_FILE}'"
    ]

    commands.each { |command| `#{command}` }
    DBConnection.open(DB_FILE)
  end

  #Returns the refernece to the initiated databse or creates and populates a new one.
  def self.instance
    open(DB_FILE) if @db.nil?

    @db
  end

  def self.execute(*args)
    instance.execute(*args)
  end
  #
  def self.execute2(*args)
    instance.execute2(*args)
  end

  # Returns the row id of the last successful insert into the table.
  def self.last_insert_row_id
    instance.last_insert_row_id
  end
end
