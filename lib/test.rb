require_relative 'sql_object'

class Pet < SQLObject
  self.finalize!
end


p Pet.table_name
puts
p Pet.columns
puts
pet = Pet.new
puts 'An instance of Pet respondes to attribute method calls.'
p pet.respond_to? :name
p pet.respond_to? :id

pet.name = 'Cat Name'
p pet.name
