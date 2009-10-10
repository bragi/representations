module ResourceRepresentations
  VAR_REPRESENTATION_SUFFIX = '_representation'
  def representation_for(object, template, name=nil, parent=nil)
    representation_class = if object.is_a?(ActiveRecord::Base)
      ActiveRecordRepresentation
    else
      "ResourceRepresentations::#{object.class}Representation".constantize rescue DefaultRepresentation
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
    
    def to_s
      ERB::Util::h(@value.to_s)
    end
    def delegate_method(method_name, *args)
      @template.send(method_name, *args)
    end
    def with_block(&block)
      yield self if block_given?
    end
  end
  
  class DefaultRepresentation < Representation
    def label
      %Q{<label for="#{name}">#{ERB::Util::h(name.humanize)}</label>}
    end
     
    def text_field
      children = Array.new
      children.push(@name)
      parent = @parent
      while parent.nil? == false do #iterate parent tree
       children.push(parent.instance_variable_get(:@name))
       parent = parent.instance_variable_get(:@parent)
      end #children looks something like that [name, profile, user]
      name_attr_value = children.pop 
      children.reverse!
      children.each do |x| 
        name_attr_value += "[" + x + "]"
      end
      %Q{<input type="text" name="#{name_attr_value}" value="#{@value}" id="#{@name}"/>}
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
      @template.concat(delegate_method(:form_tag, @value))
      @template.concat(content)
      @template.concat("</form>")
      self
    end

    def method_missing(method_name, *args, &block)
      method = <<-EOF
        def #{method_name}(*args, &block)
          @#{method_name}_VAR_REPRESENTATION_SUFFIX ||= ResourceRepresentations.representation_for(@value.#{method_name}, @template, "#{method_name}", self)
          @#{method_name}_VAR_REPRESENTATION_SUFFIX.with_block(&block)
          @#{method_name}_VAR_REPRESENTATION_SUFFIX
        end
      EOF
      self.class.class_eval(method, __FILE__, __LINE__)

      self.send(method_name, &block)
    end
  end
end
