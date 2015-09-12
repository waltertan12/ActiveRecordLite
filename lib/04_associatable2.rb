require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    through_options = self.assoc_options[through_name]

    define_method(name) do
      source_options  = 
        through_options.model_class.assoc_options[source_name]
      
      join_klass  = through_options.model_class
      join_key    = through_options.foreign_key
      join_id     = self.send(join_key)
      join_object = join_klass.find(join_id)

      final_klass = source_options.model_class
      final_key   = source_options.foreign_key
      final_id   = join_object.send(final_key)

      final_klass.where({id: final_id}).first
    end
  end
end
