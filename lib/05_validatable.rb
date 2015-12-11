require_relative '01_sql_object'
require 'set'

module Validatable
  def validates(column, options = {})
    @to_validate = {} if @to_validate.nil?
    @to_validate[column] = options
  end

  def valid?(object)
    return true if @to_validate.nil?
    @to_validate.all? do |column, validation|
      instance_value = object.send(column)

      valid = true

      if !validation[:presence].nil?
        valid &= validation[:presence] == !instance_value.nil?
      end
      if !validation[:uniqueness].nil?
        all_instances = self.all
        values = Set.new

        all_instances.all? do |instance|
          valid &= !values.add?(instance.send(column)).nil? && 
          instance_value != instance.send(column)
        end
      end
      if !validation[:length].nil?
        validation[:length].each do |len_validation|

          check = len_validation[0]
          param = validation[:length][check]

          case check
          when :max
            valid &= instance_value.length <  param
          when :min
            valid &= instance_value.length >= param
          when :in
            valid &= instance_value.length <  param.max &&
            instance_value.length >= param.min
          end
        end
      end

      valid
    end
  end
end

module ValidatableInstance
  # Overwrite instance method #save
  def self.included(base)
    base.class_eval do
      def save
        if self.class.valid?(self)
          if id
            update
          else
            insert
          end
        else
          false
        end
      end
    end
  end
end

class SQLObject 
  extend Validatable
  include ValidatableInstance
end