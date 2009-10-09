# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def r(model)
    r = ResourceRepresentations.representation_for(model, self, model.class.to_s.downcase)
    yield r if block_given?
    r
  end
end
