module Representations
  
  # Representation for Date object 
  class DateRepresentation < Representation
    def select(passed_options = {}, html_options = {})
      tree = get_parents_tree
      names = get_html_name_attribute_value(tree)
      names.pop
      options = { :object => @parent.instance_variable_get(:@value) }
      options.merge!(passed_options)
      @template.date_select(names.join, @name, options, html_options)
    end
    
    def _nested_html_field_name
      @name
    end
  end
  #Something like aliases
  class TimeWithZoneRepresentation < DateRepresentation
  end
  class DateTimeRepresentation < DateRepresentation
  end
end

