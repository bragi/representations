module ResourceRepresentations
  def representation_for(object, template, name=nil)
  
    representation_class = if object.is_a?(ActiveRecord::Base)
      ActiveRecordRepresentation
    else
      "#{object.class}Representation".constantize rescue DefaultRepresentation
    end
    representation_class.new(object, template, name, parent)
  end

  module_function :representation_for
  
  class Representation
    
    attr_accessor :value
    attr_accessor :name
    attr_accessor :output_buffer
    attr_accessor :template
    
    def initialize(value, template, name=nil)
      self.value = value
      self.name = name
      self.template = template
    end
    
    def to_s
      delegate(:h, value.to_s)
    end
    def delegate_method(name, *args)
      template.send(name, *args)
    end
  end
  
  class DefaultRepresentation < Representation
    def label
      %Q{<label for="#{name}">#{delegate_method(:h, name.humanize)}</label>}
    end
    
    def text_field
      %Q{<input type="text" name="#{name}" value="#{value}" id="#{name}"/>}
    end
  end

  class ActiveRecordRepresentation < Representation
    def form(&block)
      raise "You need to provide block to form representation" unless block_given?
      content = template.capture(self, &block)
      template.concat(delegate_method(:form_tag, value))
      template.concat(content)
      template.concat("</form>")
      self
    end

    def method_missing(name, *args)
      method = <<-EOF
        def #{name}
          @#{name} ||= ResourceRepresentations.representation_for(value.#{name}, template, "#{name}")
        end
      EOF
      self.class.class_eval(method, __FILE__, __LINE__)

      self.send(name)
    end
  end
end
