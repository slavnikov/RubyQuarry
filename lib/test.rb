require_relative 'sql_object'

class Pet < SQLObject
  self.finalize!
end


pet = Pet.new({name: 'Some Pet Name', owner_id: 3})
pet_id = pet.insert

p pet_id
p Pet.find(pet_id)
pet.name = 'A good name'
pet.update
p Pet.find(pet_id)
