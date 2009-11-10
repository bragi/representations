require 'representation.rb'
require 'default_representation.rb'
require 'associations_representation.rb'
require 'active_record_representation.rb'
require 'date_representation.rb'
module Representations
  
  #Currently this method is never called but maybe someday it will have to be :-)
  #Changes ActionController::PolymorphicRoutes#polymorphic_path so it can handle R
  def self.eval_polymorphic_routes
    ActionController::PolymorphicRoutes.class_eval do
      def polymorphic_path_with_r(object, options = {})
        object.isa_a?(Representation) ? polymorphic_path_without_r(object.instance_variable_get(:@value), options) : polymorphic_path_without_r(object, options)
      end
      alias_method_chain :polymorphic_path, :r
    end
  end
  #Enables automatic wrapping
  #Currently there's no way of disabling it
  def self.enable_automatic_wrapping=(value)
    if value
      ActionView::Base.class_eval{ self.alias_method_chain :instance_variable_set, :r }
    end
  end
  #Creates Representation for object passed as a paremeter, type of the representation
  #depends on the type of the object
  def representation_for(object, template, name, parent=nil)
    representation_class =
      begin
        if object.is_a?(ActiveRecord::Base)
          ActiveRecordRepresentation
        elsif parent && parent.instance_variable_get(:@value).class.reflections[name.to_sym] && parent.instance_variable_get(:@value).class.reflections[name.to_sym].macro == :has_one
          parent.instance_variable_get(:@value).send(name+'=', parent.instance_variable_get(:@value).class.reflections[name.to_sym].klass.new) if parent.instance_variable_get(:@value).send(name).nil? #create new AR object
          object = parent.instance_variable_get(:@value).send(name)
          Representations::ActiveRecordRepresentation
        else
          "Representations::#{object.class.to_s.demodulize}Representation".constantize 
        end
      rescue 
        AssociationsRepresentation if object.ancestors.include?(ActiveRecord::Associations) rescue DefaultRepresentation
      end
    representation_class.new(object, template, name, parent)
  end

  module_function :representation_for

end
