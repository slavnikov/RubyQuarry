require_relative 'associatable'

class Pet < SQLObject
  self.finalize!
end

class Owner < SQLObject
  self.finalize!
end

Pet.belongs_to(:owner)

pet = Pet.find(1)
p pet
p pet.owner
