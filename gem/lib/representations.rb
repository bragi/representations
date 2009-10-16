module Representations
  def representation_for(object, template, name=nil, parent=nil)
    representation_class = if object.is_a?(ActiveRecord::Base)
      ActiveRecordRepresentation
    else
      "Representations::#{object.class.to_s.demodulize}Representation".constantize rescue DefaultRepresentation
    end
    representation_class.new(object, template, name, parent)
  end

  module_function :representation_for
  
  class Representation 
    
    
    def initialize(value, template, name=nil, parent=nil)
      @value = value
      @name = name
      @template = template
      @parent = parent
    end

    def id
      @value
    end
    
    def to_s
      ERB::Util::h(@value.to_s)
    end
    def with_block(&block)
      yield self if block_given?
    end
    def method_missing(method_name, *args, &block)
      method = <<-EOF
        def #{method_name}(*args, &block)
          @__#{method_name} ||= Representations.representation_for(@value.#{method_name}, @template, "#{method_name}", self)
          @__#{method_name}.with_block(&block)
          @__#{method_name} if block.nil?
        end
      EOF
      ::Representations::ActiveRecordRepresentation.class_eval(method, __FILE__, __LINE__)

      self.__send__(method_name, &block)
    end
    def label(value, html_options = {})
      tree = get_parents_tree
      for_attr_value = tree.join('_')
      tags = get_tags(html_options, {:for => for_attr_value})
      value = ERB::Util::h(@name.humanize) if value.nil?
      %Q{<label #{tags}>#{value}</label>}
    end



    protected
    def get_parents_tree
      children_names = Array.new
      parent = @parent
      children_names.push(@name)
      while parent.nil? == false do #iterate parent tree
        children_names.push(parent.instance_variable_get(:@name))
        parent = parent.instance_variable_get(:@parent)
      end #children_names now looks something like that [name, profile, user]
      children_names.reverse
    end
    def get_html_name_attribute_value(tree)
      root_name = tree.delete_at(0)
      name = Array.new
      tree.each_index do |idx| 
        name[idx] =  if idx < tree.length - 1
          "[" + tree[idx] + "_attributes]"
        else
          "[" + tree[idx] + "]"
        end
      end
      name.unshift(root_name)
    end
    def get_tags(user_options, base_options)
      base_options.merge!(user_options)
      base_options.stringify_keys!
      base_options.map{ |key, value| %(#{key}="#{value}" ) }
    end
    end

    class DefaultRepresentation < Representation

      #not tested in the view
      def check_box(checked_value = "1", unchecked_value = "0", html_options = {})
        tree = get_parents_tree
        id_attr_value = tree.join('_') 
        name_attr_value = get_html_name_attribute_value(tree)
        tags = get_tags(html_options, {:value => checked_value, :id => id_attr_value, :name=>name_attr_value})
      %Q{<input type="checkbox" #{tags}/>\n<input type="hidden" value="#{unchecked_value}" id="#{id_attr_value}" name="#{name_attr_value}"/>}
      end
      #not tested in the view
      def file_field(html_options = {})
        tree = get_parents_tree
        id_attr_value = tree.join('_') 
        tags = get_tags(html_options, {:value => to_s, :id => id_attr_value, :name=>get_html_name_attribute_value(tree)})
      %Q{<input type="file" #{tags}/>}
      end
      #not tested in the view
      def hidden_field(html_options = {})
        tree = get_parents_tree
        id_attr_value = tree.join('_') 
        tags = get_tags(html_options, {:value => to_s, :id => id_attr_value, :name=>get_html_name_attribute_value(tree)})
      %Q{<input type="hidden" #{tags}/>}
      end
      def text_field(html_options = {})
        tree = get_parents_tree
        id_attr_value = tree.join('_') 
        tags = get_tags(html_options, {:value => to_s, :id => id_attr_value, :name=>get_html_name_attribute_value(tree)})
      %Q{<input type="text" #{tags}/>}
      end
      def text_area(html_options = {})
        tree = get_parents_tree
        id_attr_value = tree.join('_') 
        tags = get_tags(html_options, {:id => id_attr_value, :name => get_html_name_attribute_value(tree)})
      %Q{<textarea #{tags}>\n#{to_s}\n</textarea>}
      end
      def password_field(html_options = {})
        tree = get_parents_tree
        id_attr_value = tree.join('_') 
        tags = get_tags(html_options, {:value => to_s, :id => id_attr_value, :name=>get_html_name_attribute_value(tree)})
      %Q{<input type="password" #{tags}/>}
      end
      def radio_button(value, html_options = {})
        tree = get_parents_tree
        id_attr_value = tree.join('_') + "_#{value}"
        name_attr_value = get_html_name_attribute_value(tree)
        tags = get_tags(html_options, {:name => name_attr_value, :value=>value, :id=>id_attr_value, :checked=>"#{@value.capitalize==value.capitalize}"})
      %Q{<input type="radio" #{tags}/>}
      end
      def radio_button_label(radio_button_value, value = nil, html_options = {})
        tree = get_parents_tree
        for_attr_value = tree.join('_') + "_#{radio_button_value}"
        value = radio_button_value.capitalize if value.nil?
        tags = get_tags(html_options, {:for => for_attr_value})
      %Q{<label #{tags}>#{ERB::Util::h(value)}</label>}
        end
      end
      class NilClassRepresentation < Representation
        def method_missing(method_name, *args)
          return self
        end
        def with_block(&block)
        end
        def to_s
          return ''
        end
      end
      class ActiveRecordRepresentation < Representation
        def form(&block)
          raise "You need to provide block to form representation" unless block_given?
          content = @template.capture(self, &block)
          @template.concat(@template.form_tag(@value))
          @template.concat(content)
          @template.concat("</form>")
          self
        end
      end
      class TimeWithZoneRepresentation < Representation
        def select(passed_options = {}, html_options = {})
          options = {:defaults => {:day => @value.day, :month => @value.month, :year => @value.year}}
          options.merge!(passed_options)
          tree = get_parents_tree
          tree.pop
          name = get_html_name_attribute_value(tree)
          @template.date_select(name, @name, options, html_options)
        end
      end
    end
