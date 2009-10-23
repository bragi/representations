class ActionView::Base
  def instance_variable_set(symbol, obj)
    obj = r(obj) if Representations::enable_automatic_wrapping
    super
  end
end

