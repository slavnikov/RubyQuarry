require_relative 'db_connection'
require_relative 'sql_object'

module Searchable

  # Return an array of objects that fit the search criteria.
  def where(params)
    where_clause = ""
    params.each do |name_attr, value|
      where_clause += "#{name_attr} = '#{value}' AND "
    end
    where_clause = where_clause[0...-4]

    db_output = DBConnection.execute (<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_clause}
    SQL

    return nil unless db_output

    db_output.map { |attr_hash| self.new(attr_hash) }
  end
end

class SQLObject
  extend Searchable
end
