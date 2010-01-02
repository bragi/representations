module Representations
  #Representation for ActiveRecord::Base objects
  class ActiveRecord < Base
    
    # TODO: refactor super handling
    def __representation_for(value, name)
      super if value

      # Handle empty has_one relations
      reflection = __value_class.reflections[name.to_sym]
      class_name = if reflection && (reflection.macro == :has_one || reflection.macro == :belongs_to)
        ClassSearch.new.class_for_class(reflection.klass)
      elsif
        super
      end
      class_name.new(value, __template, name, self, {:namespace => __namespace, :value_class => reflection.klass})
    end
    
    # Render partial with the given name and given namespace as a parameter
    def partial(partial_name, namespace = nil)
      if namespace
        @template.render(:partial => "#{namespace}/#{@value.class.to_s.pluralize.downcase}/#{partial_name}")
      else 
        @template.render(:partial => "#{@template.polymorphic_path(@value)[/\/.*\//]}#{partial_name}")
      end
    end
    
    # Render partial if it has 'has_one' association with the other model, 
    # otherwise do normal to_s
    def to_s
      @parent && @parent.instance_variable_get(:@value).class.reflections[:"#{@name}"].macro == :has_one ? partial(@name) : super
    end
    
    # Form tag, namespace depends on the namespace of the controller.
    def form(path = nil, &block)
      raise "You need to provide block to form representation" unless block_given?
      content = @template.capture(self, &block)
      @value.new_record? ? options = {:method => :post} : options = {:method => :put}
      path = @template.polymorphic_path(_namespaced_value) unless path
      @template.concat(@template.form_tag(path, options))
      @template.concat(content)
      @template.concat(@template.submit_tag("ok"))
      @template.concat("</form>")
      self
    end
    
    # Creates link to representation. When you do not provide +link_title+
    # sane value (class of represented object) will be used.
    #
    # ==== Arguments
    #
    # * <tt>link_title/tt> - Title of the link
    # * <tt>options</tt> - HTML options for the link plus two options:
    #    * <tt>:action</tt> - target action of the link, for example
    #      <tt>:new</tt> or <tt>:edit/tt>
    #    * <tt>:anchor</tt> - target anchor of the link
    def link(link_title = nil, options = {})
      # Sane link_title value
      link_title = @value.class.to_s.demodulize.tableize.singularize.humanize unless link_title
      
      # Extract URL options
      action = options.delete(:action)
      anchor = options.delete(:anchor)
      @template.link_to(link_title, @template.polymorphic_path(_namespaced_value, :action => action, :anchor => anchor), options)
    end
    
    # clone Representation object and set it's @namespace variable to required value
    def namespace(a)
      namespaced_representation = self.clone
      namespaced_representation.current_namespace(a)
      namespaced_representation
    end
    
    # Forwards ActiveRecord invocation and wraps result in appropriate Representation
    # Suppose that User extends ActiveRecord::Base:
    #   ar_user = User.new
    #   ar_user.nick = 'foo'
    #   user = r(ar_user) #user is now ActiveRecordRepresentation
    #   user.nick.text_field #method_missing will be called on user with method_name = 'nick' in which new method for user will be created and will be called. The newly created method will create a new DefaultRepresentation with @value set to the string 'foo'. Next the text_field will be called on the newly created DefaultRepresentation
    # def method_missing(method_name, *args, &block)
    #   method = <<-EOF
    #         def #{method_name}(*args, &block)
    #           @__#{method_name} ||= Representations.representation_for(@value.#{method_name}, @template, "#{method_name}", self)
    #           @__#{method_name}.with_block(&block)
    #           @__#{method_name} if block.nil? 
    #         end
    #   EOF
    #   ::Representations::ActiveRecordRepresentation.class_eval(method, __FILE__, __LINE__)
    #   self.__send__(method_name, &block)
    # end
    
    private
    
      def _namespaced_value
        @namespace + [@value]
      end
      def _nested_html_field_name
        if @parent && @parent.is_a?(Representations::AssociationsRepresentation)
          @name
        else
          "#{@name}_attributes"
        end
      end
  end
end
