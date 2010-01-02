require "#{File.dirname(__FILE__)}/representations/class_search"
require "#{File.dirname(__FILE__)}/representations/base"
require "#{File.dirname(__FILE__)}/representations/default"
require "#{File.dirname(__FILE__)}/representations/association"
require "#{File.dirname(__FILE__)}/representations/active_record.rb"
require "#{File.dirname(__FILE__)}/representations/date"
require "#{File.dirname(__FILE__)}/representations/extensions/action_view"

ActionView::Base.send :include, Representations::Extensions::ActionView

module Representations
  
  # When enabled all controller instance variables will be wrapped when 
  # transfered to view. 
  def self.enable_automatic_wrapping!
    ActionView::Base.class_eval{ self.alias_method_chain :instance_variable_set, :wrap_in_representation }
  end
  
  #Creates Representation for object passed as a paremeter, type of the representation
  #depends on the type of the object
  def representation_for(object, template, name, parent=nil)
    ClassSearch.new.class_for(object).new(object, template, name, parent)
    # representation_class =
    #   begin
    #     if object.is_a?(ActiveRecord::Base)
    #       ActiveRecordRepresentation
    #     elsif parent._is_has_one_relation(name)
    #       parent._value.send("#{name}=", parent._value.class.reflections[name.to_sym].klass.new) if parent._value.send(name).nil? #create new AR object
    #       object = parent._value.send(name)
    #       Representations::ActiveRecordRepresentation
    #     elsif object.nil? && parent.is_a?(Representations::ActiveRecordRepresentation) && sql_type = sql_type_for_name(parent, name)
    #       representation_for_sql_type(sql_type)
    #     else
    #       "Representations::#{object.class.to_s.demodulize}Representation".constantize 
    #     end
    #   rescue 
    #     AssociationsRepresentation if object.ancestors.include?(ActiveRecord::Associations) rescue DefaultRepresentation
    #   end
    # representation_class.new(object, template, name, parent)
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
