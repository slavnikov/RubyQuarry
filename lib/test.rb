require_relative 'sql_object'

class Pet < SQLObject

end

p Pet.table_name
puts
p Pet.columns
