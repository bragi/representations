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
    private
    def find_variable_name(object)
      self.instance_variables.each do |name|
        return name[1..-1] if instance_variable_get(name) == object
      end
    end
  end
end
