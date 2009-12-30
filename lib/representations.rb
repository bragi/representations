require "#{File.dirname(__FILE__)}/representations/representation"
require "#{File.dirname(__FILE__)}/representations/default_representation"
require "#{File.dirname(__FILE__)}/representations/associations_representation"
require "#{File.dirname(__FILE__)}/representations/active_record_representation.rb"
require "#{File.dirname(__FILE__)}/representations/date_representation"
require "#{File.dirname(__FILE__)}/representations/view_helpers"

ActionView::Base.send :include, Representations::ViewHelpers

module Representations
  
  #Currently this method is never called but maybe someday it will have to be :-)
  #Changes ActionController::PolymorphicRoutes#polymorphic_path so it can handle R
  def self.eval_polymorphic_routes
    ActionController::PolymorphicRoutes.class_eval do
      def polymorphic_path_with_r(object, options = {})
        object.is_a?(Representation) ? polymorphic_path_without_r(object.instance_variable_get(:@value), options) : polymorphic_path_without_r(object, options)
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
        elsif parent && parent._value.class.reflections[name.to_sym] && parent._value.class.reflections[name.to_sym].macro == :has_one
          parent._value.send("#{name}=", parent._value.class.reflections[name.to_sym].klass.new) if parent._value.send(name).nil? #create new AR object
          object = parent._value.send(name)
          Representations::ActiveRecordRepresentation
        elsif object.nil? && parent.is_a?(Representations::ActiveRecordRepresentation) && sql_type = sql_type_for_name(parent, name)
          representation_for_sql_type(sql_type)
        else
          "Representations::#{object.class.to_s.demodulize}Representation".constantize 
        end
      rescue 
        AssociationsRepresentation if object.ancestors.include?(ActiveRecord::Associations) rescue DefaultRepresentation
      end
    representation_class.new(object, template, name, parent)
  end
  
  def sql_type_for_name(object, name)
    object.instance_variable_get(:@value).class.columns.select {|column| column.name == name}.map(&:sql_type).first
  end
  
  def representation_for_sql_type(sql_type)
    case sql_type
      when "datetime", "timestamp without time zone"
        Representations::DateRepresentation
      else
        Representations::Representation
    end
  end

  module_function :representation_for

end
