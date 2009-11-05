module Representations
  #Representation for Date object 
  class DateRepresentation < Representation
    def select(passed_options = {}, html_options = {})
      tree = get_parents_tree
      names = get_html_name_attribute_value(tree)
      names.pop
      if @value
        options = {:defaults => {:day => @value.day, :month => @value.month, :year => @value.year}}
        #TODO now POSTing form is broken - value is unknown attr
        names << '[value]' #date_select helper will want to access the object
      else
        options = {:defaults => {:day => Time.now.day, :month => Time.now.month, :year => Time.now.year}}
      end
      options.merge!(passed_options)
      InstanceTag.new(object_name, method, self, options.delete(:object)).to_date_select_tag(options, html_options)
      @template.date_select(names, @name, options, html_options)
    end
  end
  #Something like alias
  class TimeWithZoneRepresentation < DateRepresentation
  end
  class DateTimeRepresentation < DateRepresentation
  end
end

