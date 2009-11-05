module Representations
  module ViewHelpers
    def r(model)
      if model.class == Representations::ActiveRecordRepresentation
        Rails.logger.info 'Object is already wrapped in Representation'
        r = model
      else
        if model.class == Array #model is an array of AR objects
          model.map!{|m| representation_for(m, self, find_variable_name(model)) if m.is_a?(ActiveRecord::Base)}
        else
          r = Representations.representation_for(model, self, find_variable_name(model)) 
        end
      end
      yield r if block_given?
      r
    end
    #This method is aliased when Representations.enable_automatic_wrappint(true) is called
    def instance_variable_set_with_r(symbol, obj)
      load ActiveSupport::Dependencies.search_for_file('representations.rb')
      if obj.is_a?(ActiveRecord::Base)
        obj = Representations.representation_for(obj, self, symbol.to_s[1..-1]) 
      elsif obj.class == Array #handle case when controller sends array of AR objects
        obj.map!{|o| Representations.representation_for(o, self, symbol.to_s[1..-1]) if o.is_a?(ActiveRecord::Base)}
      end
      instance_variable_set_without_r(symbol, obj) #call to the original method
    end
    private
    def find_variable_name(object)
      self.instance_variables.each do |name|
        return name[1..-1] if instance_variable_get(name) == object
      end
    end
  end
end
