require_relative '01_sql_object'

module Validatable
  # validate presence
  # def validates_presence(column, attribute)
    #             presence: true   ==  NOT column is not nil -> NOT FALSE
    #             presence: true   ==  NOT column is nil     -> NOT TRUE
    #             presence: false  ==  NOT column is not nil -> NOT FALSE
    #             presence: false  ==  NOT column is nil     -> NOT TRUE
  #   return if attribute[:presence] == !self.send(column).nil?
  #   raise "#{column} cannot be empty"
  # end

  # check which columns to validate
  def validates(column, options = {})
    @to_validate = {} if @to_validate.nil?
    @to_validate[column] = options
  end

  def valid?(object)
    @to_validate.all? do |column, validation|
      instance_value = object.send(column)

      if !validation[:presence].nil?
        validation[:presence] == !instance_value.nil?
      elsif !validation[:uniquness].nil?
        all_instances = self.all

        all_instances.all? do |instance|
          instance_value = instance.send(column)
        end
      elsif !validation[:length].nil?
        check = validation[:length].first[0]
        param = validation[:length][check]

        case check
        when :maximum
          instance_value.length < param
        when :minimum
          instance_value.length >= param
        when :in
          instance_value.length < param.max &&
          instance_value.length >= param.min
        end
      end
    end
  end
end

module ValidatableInstance

  def self.included(base)
    base.class_eval do
      def save
        if self.class.valid?(self)
          super
        else
          puts "FAWKKKKKKk NOT VaLiD bRoOo!1"
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