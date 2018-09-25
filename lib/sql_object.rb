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

  # Defines getter and setter methods for attributes based on the column names in the databse.
  def self.finalize!
    columns.each do |column|
      define_method(column) do
        self.attributes[column]
      end

      define_method("#{column}=") do |value|
        self.attributes[column] = value
      end
    end
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

  # When an instance is initalized with a hash of parameters and values, the
  def initialize(params = {})
    params.each do |attr_name, value|
      attr_sym = attr_name.to_sym

      raise "unknown attribute '#{attr_name}'" unless self.class.columns.include?(attr_sym)

      self.send(attr_name.to_s + "=", value)
    end
  end

  # Laxiliy instantiates attributes before they are defined in the finalize method.
  def attributes
    @attributes ||= Hash.new
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
