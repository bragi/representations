require 'representation'
require 'default_representation'
require 'associations_representation'
require 'active_record_representation'
#require 'active_record_for_form_representation'
require 'nil_class_representation'
module Representations
  #Enables automatic wrapping
  #Currently there's no way of deactivating it
  def self.enable_automatic_wrapping=(value)
    if value
      ActionView::Base.class_eval do 
       def instance_variable_set_with_r(symbol, obj)
         load ActiveSupport::Dependencies.search_for_file('representations.rb')
         obj = Representations.representation_for(obj, self, symbol.to_s[1..-1]) if obj.is_a?(ActiveRecord::Base)
         instance_variable_set_without_r(symbol, obj) #call to the original method
       end
       self.alias_method_chain :instance_variable_set, :r
     end
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
    #if wrapping a new record wrap to something else than NilClassRepresentation
    #if representation_class == NilClassRepresentation && parent.instance_variable_get(:@value).new_record?
        #representation_class = case parent.instance_variable_get(:@value).class.columns_hash[name].type
                               #when :string
                                 #DefaultRepresentation
                               #when :date
                                 #TimeWithZoneRepresentation
                               #end
    #end
    representation_class.new(object, template, name, parent)
  end

  module_function :representation_for

  #Representation for TimeWithZone object 
  class TimeWithZoneRepresentation < Representation
    def select(passed_options = {}, html_options = {})
      options = {:defaults => {:day => @value.day, :month => @value.month, :year => @value.year}}
      options.merge!(passed_options)
      tree = get_parents_tree
      name = get_html_name_attribute_value(tree)
      @template.date_select(name, @name, options, html_options)
    end
  end
end
