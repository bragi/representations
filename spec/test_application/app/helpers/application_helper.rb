# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def r(model)
    if model.class == Representations::ActiveRecordRepresentation
      Rails.logger.info 'object is already wrapped in Representation'
      r = model
    else
      r = Representations.representation_for(model, self, find_variables_name(model)) 
    end
    yield r if block_given?
    r
  end
  private
  def find_variables_name(object)
    self.instance_variables.each do |name|
      return name[1..-1] if instance_variable_get(name) == object
    end
  end
end
