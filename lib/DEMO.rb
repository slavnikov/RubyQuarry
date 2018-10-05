require_relative 'associatable_through'

class Movie < SQLObject
  belongs_to :director
  has_one_through(:studio, :director, :studio)
  finalize!
end

class Director < SQLObject
  has_many :movies
  belongs_to :studio

  self.finalize!
end

class Studio < SQLObject
  has_many :directors

  self.finalize!
end
