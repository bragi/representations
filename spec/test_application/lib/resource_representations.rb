module ResourceRepresentations
  def representation_for(object, name=nil)
    representation_class = if object.is_a?(ActiveRecord::Base)
      ActiveRecordRepresentation
    else
      "#{object.class}Representation".constantize rescue DefaultRepresentation
    end
    representation_class.new(object, name)
  end

  module_function :representation_for
  
  class Representation
    include ERB::Util
    include ActionView::Helpers
    
    attr_accessor :value
    attr_accessor :name
    
    def initialize(value, name=nil)
      self.value = value
      self.name = name
    end

    def to_s
      h(value.to_s)
    end
  end
  
  class DefaultRepresentation < Representation
    def label
      %Q{<label for="#{name}">#{h(name.humanize)}</label>}
    end
    
    def text_field
      %Q{<input type="text" name="#{name}" value="#{value}" id="#{name}"/>}
    end
  end

  class ActiveRecordRepresentation < Representation
    def form(&block)
      raise "You need to provide block to form representation" unless block_given?
      content = capture(&block)
      concat(form_tag_html(value))
      concat(content)
      concat("</form>")
      self
    end

    def method_missing(name)
      method = <<-EOF
        def #{name}
          @#{name} ||= ResourceRepresentations.representation_for(value.#{name}, "#{name}")
        end
      EOF
      self.class.class_eval(method, __FILE__, __LINE__)
      self.send(name)
    end
  end
end