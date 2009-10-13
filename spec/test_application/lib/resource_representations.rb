module ResourceRepresentations
  def representation_for(object, template, name=nil, parent=nil)
    representation_class = if object.is_a?(ActiveRecord::Base)
      ActiveRecordRepresentation
    else
      "ResourceRepresentations::#{object.class.to_s.demodulize}Representation".constantize rescue DefaultRepresentation
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
          @__#{method_name} ||= ResourceRepresentations.representation_for(@value.#{method_name}, @template, "#{method_name}", self)
          @__#{method_name}.with_block(&block)
          @__#{method_name} if block.nil?
        end
      EOF
      ::ResourceRepresentations::ActiveRecordRepresentation.class_eval(method, __FILE__, __LINE__)

      self.__send__(method_name, &block)
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
      name = tree.delete_at(0)
      tree.each do |x| 
        name += "[" + x + "]"
      end
      name
    end
  end

  class DefaultRepresentation < Representation
    def label
      %Q{<label for="#{@name}">#{ERB::Util::h(@name.humanize)}</label>}
    end

    def text_field
      tree = get_parents_tree
      %Q{<input type="text" name="#{get_html_name_attribute_value(tree)}" value="#{@value}" id="#{@name}"/>}
    end
    def radio_button(method)
      tree = get_parents_tree
      model_name = tree.delete_at(0)
    end
  end
  class NilClassRepresentation < Representation
    def method_missing(method_name, *args)
      return self
    end
    def with_block(&block)
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
