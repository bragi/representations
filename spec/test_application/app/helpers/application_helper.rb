# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def r(model)
    r = ResourceRepresentations.representation_for(model)
    yield r if block_given?
    r
  end
end
