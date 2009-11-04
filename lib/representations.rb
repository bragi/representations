load 'representation.rb'
load 'default_representation.rb'
load 'associations_representation.rb'
load 'active_record_representation.rb'
load 'nil_class_representation.rb'
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
        else
          "Representations::#{object.class.to_s.demodulize}Representation".constantize 
        end
      rescue 
        AssociationsRepresentation if object.ancestors.include?(ActiveRecord::Associations) rescue DefaultRepresentation
      end
    representation_class.new(object, template, name, parent)
  end

  module_function :representation_for

  #Representation for TimeWithZone object 
  class TimeWithZoneRepresentation < Representation
    def select(passed_options = {}, html_options = {})
      if @value
        options = {:defaults => {:day => @value.day, :month => @value.month, :year => @value.year}}
      else
        options = {:defaults => {:day => Time.now.day, :month => Time.now.month, :year => Time.now.year}}
      end
      options.merge!(passed_options)
      tree = get_parents_tree
      name = get_html_name_attribute_value(tree)
      @template.date_select(name, @name, options, html_options)
    end
  end
end
