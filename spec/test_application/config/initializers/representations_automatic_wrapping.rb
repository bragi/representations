class ActionView::Base
  def instance_variable_set(symbol, obj)
    obj = r(obj)
    super
  end
end

