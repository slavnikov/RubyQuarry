require_relative 'searchable'
require 'active_support/inflector'

# A utility for the user of the two classes after it. Sets up the attr_accessors for the three necessary variables and automates the access to model and table name.
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.to_s.constantize
  end

  def table_name
    return 'humans' if class_name.to_s == 'Human'
    class_name.tableize
  end
end

# The below two classes automate the creation of variables that store the information necessary for associations to be able to make correct queries.
class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || (name.to_s + "_id").to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.to_s.capitalize
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] || (self_class_name.downcase + "_id").to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.to_s.singularize.capitalize
  end
end

module Associatable

  #when called on the class, creates an association by adding an instance method named after the association. When called, the instance method will query the databse for a record in the association's table with a primary key identical to the foreign key of the instance. Will return a single object.
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)

    define_method(name) do
      options
      .model_class
      .where({options.primary_key => self.send(options.foreign_key)})
      .first
    end
  end

  #Same as belongs_to but the association instance method return an array of objects, even if there is only one object that matches the query.
  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)

    define_method(name) do
      options
      .model_class
      .where({options.foreign_key => self.send(options.primary_key)})
    end
  end
end

class SQLObject
  extend Associatable
end
