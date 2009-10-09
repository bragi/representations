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
    
    attr_accessor :output_buffer
    attr_accessor :template
    attr_accessor :parent
    
    def initialize(value, template, name=nil, parent=nil)
      @value = value
      @name = name
      @template = template
      @parent = parent
    end
    
    def to_s
      ERB::Util::h(value.to_s)
    end
    def delegate_method(name, *args)
      template.send(name, *args)
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
      Rails.logger.debug "Name: #{name}"
      Rails.logger.debug "Parent.name: #{parent.name}" unless @parent.nil?
      root_name = ''
      children = Array.new
      if parent.nil?
        root_name += @name
      else
        _parent = @parent
        begin
          children.push(@name)
          root_name = _parent.name
          _parent = @parent.parent
        end while _parent != nil #iterate children to find the top parent
      end
      name_attr_value = root_name
      children.each do |x| 
        name_attr_value += "[" + x + "]" 
      end
      %Q{<input type="text" name="#{name_attr_value}" value="#{@value}" id="#{@name}"/>}
    end
  end
  class NilClassRepresentation < Representation
    def method_missing(name, *args)
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
          debugger
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
