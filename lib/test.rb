require_relative 'associatable2'

class Pet < SQLObject
  self.finalize!
end

class Owner < SQLObject
  self.finalize!
end

class Home < SQLObject
  self.finalize!
end

Pet.belongs_to(:owner)
Pet.has_one_through(:home, :owner, :home)
Owner.belongs_to(:home)

pet = Pet.find(1)
p pet
p pet.owner
p pet.owner.home
p pet.home
