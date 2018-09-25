require_relative 'searchable'
require 'active_support/inflector'

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

  def assoc_options
    @assoc_options ||= {}
  end

  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)

    define_method(name) do
      options
      .model_class
      .where({options.primary_key => self.send(options.foreign_key)})
      .first
    end

    @assoc_options ? (@assoc_options[name.to_sym] = options) : @assoc_options = {name.to_sym => options}
  end

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
