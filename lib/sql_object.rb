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

  # Returns an array of class objects with their respective attributes. These can then be accessed with the instance methods named after the column names.
  def self.all
    raw_hash = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL

    self.parse_all(raw_hash)
  end

  def self.parse_all(results)
    results.map { |raw_hash| self.new(raw_hash) }
  end

  # Creates a new object instance from a record retreived from the databse.
  def self.find(id)
    datum = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = ?;
    SQL
    .first

    datum.nil? ? nil : self.new(datum)
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

  #Returns an array of just attribute values.
  def attribute_values
    values = []

    self.attributes.each do |_, value|
      values << value
    end

    values
  end

  #Insertes a record into the databse and returns its id upon successful insertion.
  def insert
    col_names = self.class.columns[1..-1].join(', ')
    values_set = self.attribute_values.map { |value| "'" + value.to_s + "'" }.join(', ')

    DBConnection.execute(<<-SQL)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{values_set})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    col_names = self.class.columns[1..-1].join(', ')
    set_clause = ""
    self.attributes.each do |attr_name, value|
      set_clause += "#{attr_name} = '#{value}', " unless attr_name == :id
    end
    set_clause = set_clause[0...-2]

    DBConnection.execute(<<-SQL )
      UPDATE
        #{self.class.table_name}
      SET
        #{set_clause}
      WHERE
        id = #{self.id}
    SQL
  end

  def save
    self.id ? self.update : self.insert
  end
end
