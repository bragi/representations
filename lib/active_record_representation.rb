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
      path = @template.polymorphic_path(@value) unless path
      @template.concat(@template.form_tag(path, options))
      @template.concat(content)
      @template.concat(@template.submit_tag("ok"))
      @template.concat("</form>")
      self
    end
    #method not tested
    def namespace(passed_namespace)
      path = @template.polymorphic_path(@value) << passed_namespace.to_s
      view = @template.clone
      #singleton method to modify default polymorphic_path in single variable
      def view.polymorphic_path
        "#{path}"
      end
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
