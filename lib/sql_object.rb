require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  #Returns an array column names as symbols.
  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL

    @columns.first.map(&:to_sym)
  end

  def self.finalize!
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  #Returns the table name as a string.
  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all

  end

  def self.parse_all(results)

  end

  def self.find(id)

  end

  def initialize(params = {})

  end

  def attributes
    # ...
  end

  def attribute_values

  end

  def insert

  end

  def update

  end

  def save

  end
end
