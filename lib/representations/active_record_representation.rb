module Representations
  #Representation for ActiveRecord::Base objects
  class ActiveRecordRepresentation < Representation
    #Render partial with the given name and given namespace as a parameter
    def partial(partial_name, namespace = nil)
      if namespace
        @template.render(:partial => "#{namespace}/#{@value.class.to_s.pluralize.downcase}/#{partial_name}")
      else 
        @template.render(:partial => "#{@template.polymorphic_path(@value)[/\/.*\//]}#{partial_name}")
      end
    end
    #Render partial if it has 'has_one' association with the other model, otherwise do normal to_s
    def to_s
      @parent && @parent.instance_variable_get(:@value).class.reflections[:"#{@name}"].macro == :has_one ? partial(@name) : super
    end
    #Form tag, namespace depends on the namespace of the controller.
    def form(path = nil, &block)
      raise "You need to provide block to form representation" unless block_given?
      content = @template.capture(self, &block)
      @value.new_record? ? options = {:method => :post} : options = {:method => :put}
      if path
        path = path
      elsif @namespace      
        path = @namespace.to_s
      else
        path = @template.polymorphic_path(@value)
      end
      @template.concat(@template.form_tag(path, options))
      @template.concat(content)
      @template.concat(@template.submit_tag("ok"))
      @template.concat("</form>")
      self
    end
    def link(link_title = "", passed_options = {})
      if @value
        a = %Q{"#{@value.class.to_s.downcase.pluralize}/#{@value.id}}
        passed_options[:view] ? a << "/" << passed_options[:view].to_s << '"': a << '"' 
        link_title.to_s.empty? ? b = "#{@value.class.to_s} #{@value.id}" : b = link_title.to_s
        %Q(<a href=#{a}>#{b}</a>)
      else
        ""
      end
    end
    #clone Representation object and set it's @namespace variable to required value
    def namespace(a)
      namespaced_representation = self.clone
      namespaced_representation.namespace = current_namespace(a)
      namespaced_representation
    end
    #Forwards ActiveRecord invocation and wraps result in appropriate Representation
    #Suppose that User extends ActiveRecord::Base:
    #ar_user = User.new
    #ar_user.nick = 'foo'
    #user = r(ar_user) #user is now ActiveRecordRepresentation
    #user.nick.text_field #method_missing will be called on user with method_name = 'nick' in which new method for user will be created and will be called. The newly created method will create a new DefaultRepresentation with @value set to the string 'foo'. Next the text_field will be called on the newly created DefaultRepresentation
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
  end
end
