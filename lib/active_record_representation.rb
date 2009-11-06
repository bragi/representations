module Representations
  #Representation for ActiveRecord::Base objects
  class ActiveRecordRepresentation < Representation
    #Render partial with the given name and given namespace as a parameter
    def partial(partial_name, namespace = nil)
      namespace = get_namespace unless namespace
      namespace += '/'
      path = @name.pluralize
      path = namespace + path
      path.downcase!
      @template.render(:partial => "#{path}/#{partial_name}")
    end
    #Render partial if it has 'has_one' association with the other model, otherwise do normal to_s
    def to_s
      @parent && @parent.instance_variable_get(:@value).class.reflections[:"#{@name}"].macro == :has_one ? partial(@name) : super
    end
    #Form tag, namespace depends on the namespace of the controller.
    def form(&block)
      raise "You need to provide block to form representation" unless block_given?
      namespace = get_namespace
      namespace = '/' + namespace unless namespace.blank?
      path = namespace + '/' + @name.pluralize
      path.downcase!
      if @value.new_record?
        #path += 
        r_for_form = NewRecordRepresentation.new(@value, @template, @name, @parent)
        content = @template.capture(r_for_form, &block)
        @template.concat(@template.form_tag(path, :method => "post"))
      else
        content = @template.capture(self, &block)
        path += '/' + "#{@value.id}"
        @template.concat(@template.form_tag(path, :method => "put"))
      end
      @template.concat(content)
      @template.concat("</form>")
      self
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
    private
    #Gets path to namespace (i.e. if controller is Good::Bad::Ugly::UsersController the R is in the namespace good/bad/ugly)
    def get_namespace
        namespace = @template.controller.class.parent_name.split('::') rescue []
        namespace = namespace.join('/') 
    end
    #Wraps new ActiveRecord::Base objects. This object will not create NilClassR for nil objects 
    #For attr with has_one association it will wrap in ActiveRecordRepresentation::NewRecordRepresentation
    #For other associations it will wrap in AssociationsRepresentation
    #For other datatypes it will wrap in R that corresponds to the datatype in the db
    class NewRecordRepresentation < Representation
      def method_missing(method_name, *args, &block)
        method = <<-EOF
            def #{method_name}(*args, &block)
              representation_class = if @value.class.reflections[:#{method_name}] && @value.class.reflections[:#{method_name}].macro == :has_one
                  @value.#{method_name} = "#{method_name}".classify.constantize.new
                  Representations::ActiveRecordRepresentation::NewRecordRepresentation
                elsif @value.#{method_name}.respond_to?(:ancestors) && @value.#{method_name}.ancestors.include?(ActiveRecord::Associations)
                  Representations::AssociationsRepresentation
                else
                  case @value.class.columns_hash["#{method_name}"].type
                                 when :date 
                                   Representations::DateRepresentation
                                 when :datetime 
                                   Representations::DateRepresentation
                                 else
                                   Representations::DefaultRepresentation
                                 end
                end
              @__#{method_name} ||= representation_class.new(@value.#{method_name}, @template, "#{method_name}", self)
              @__#{method_name}.with_block(&block)
              @__#{method_name} if block.nil?
            end
        EOF
        ::Representations::ActiveRecordRepresentation::NewRecordRepresentation.class_eval(method, __FILE__, __LINE__)
        self.__send__(method_name, &block)
      end
    end
  end
end
