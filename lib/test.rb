require_relative 'sql_object'

class Pet < SQLObject
  self.finalize!
end


# pet = Pet.new({name: 'Test Pet', owner_id: 1})
# pet_id = pet.save
# p pet_id
earl = Pet.find_by(name: 'Earl')
p earl
