module Representations
  class DefaultRepresentation < Representation
    #not tested in the view
    #Returns string with html check box tag
    def check_box(checked_value = "1", unchecked_value = "0", html_options = {})
      tree = get_parents_tree
      id_attr_value = tree.collect{ |x| x[0] }.join('_') 
      name_attr_value = get_html_name_attribute_value(tree)
      tags = get_tags(html_options, {:value => checked_value, :id => id_attr_value, :name=>name_attr_value})
      %Q{<input type="checkbox" #{tags}/>\n<input type="hidden" value="#{unchecked_value}" id="#{id_attr_value}" name="#{name_attr_value}"/>}
    end
    #not tested in the view
    #Returns string with html file field tag
    def file_field(html_options = {})
      tree = get_parents_tree
      id_attr_value = tree.collect{ |x| x[0] }.join('_') 
      tags = get_tags(html_options, {:value => to_s, :id => id_attr_value, :name=>get_html_name_attribute_value(tree)})
      %Q{<input type="file" #{tags}/>}
    end
    #not tested in the view
    #Returns string with html hidden input tag
    def hidden_field(html_options = {})
      tree = get_parents_tree
      id_attr_value = tree.collect{ |x| x[0] }.join('_') 
      tags = get_tags(html_options, {:value => to_s, :id => id_attr_value, :name=>get_html_name_attribute_value(tree)})
      %Q{<input type="hidden" #{tags}/>}
    end
    #Returns string with html text input tag
    def text_field(html_options = {})
      tree = get_parents_tree
      id_attr_value = tree.collect{ |x| x[0] }.join('_') 
      tags = get_tags(html_options, {:value => to_s, :id => id_attr_value, :name=>get_html_name_attribute_value(tree)})
      %Q{<input type="text" #{tags}/>}
    end
    #Returns string with html text area tag
    def text_area(html_options = {})
      tree = get_parents_tree
      id_attr_value = tree.collect{ |x| x[0] }.join('_') 
      tags = get_tags(html_options, {:id => id_attr_value, :name => get_html_name_attribute_value(tree)})
      %Q{<textarea #{tags}>\n#{to_s}\n</textarea>}
    end
    #Returns string with html password tag
    def password_field(html_options = {})
      tree = get_parents_tree
      id_attr_value = tree.collect{ |x| x[0] }.join('_') 
      tags = get_tags(html_options, {:value => to_s, :id => id_attr_value, :name=>get_html_name_attribute_value(tree)})
      %Q{<input type="password" #{tags}/>}
    end
    #Returns string with html radio button tag
    def radio_button(value, html_options = {})
      tree = get_parents_tree
      id_attr_value = tree.collect{ |x| x[0] }.join('_') + "_#{value}"
      name_attr_value = get_html_name_attribute_value(tree)
      tags = get_tags(html_options, {:name => name_attr_value, :value=>value, :id=>id_attr_value, :checked=>"#{@value.capitalize==value.capitalize}"})
      %Q{<input type="radio" #{tags}/>}
    end
    #Returns string with html label tag with for attribute set to the radio button of this object
    def radio_button_label(radio_button_value, value = nil, html_options = {})
      tree = get_parents_tree
      for_attr_value = tree.collect{ |x| x[0] }.join('_') + "_#{radio_button_value}"
      value = radio_button_value.capitalize if value.nil?
      tags = get_tags(html_options, {:for => for_attr_value})
      %Q{<label #{tags}>#{ERB::Util::h(value)}</label>}
    end
  end
end
