module Representations
  class Base
    # value - object that will be represented
    # template - template in which rendering will take place
    # name - name of the object in representation chain
    # parent - previous object in representation chain
    # namespace - namespace in which object is presented
    def initialize(value, template, name, parent=nil, namespace=[])
      @value = value
      @name = name
      @template = template
      @parent = parent
      @namespace = namespace
    end
    
    # Defines double-underscored properties
    %w(value name template parent namespace).each do |property|
      method = <<-EOT
        def __#{property}
          @#{property}
        end
        
        def __#{property}=(value)
          @#{property} = value
        end
      EOT
      class_eval(method, __FILE__, __LINE__)
    end

    def __representation_for(value, name)
      ClassSearch.new.class_for(value).new(value, __template, name, self, __namespace)
    end

    # Forward method to represented value, wrap returned value in 
    # representation. Yield it to a block if it was given and return new 
    # represetation anyway.
    def method_missing(method, *arguments)
      value = __value.send(method, *arguments)
      representation = __representation_for(value, method)
      yield representation if block_given?
      representation
    end
    
    # TODO: remove?
    # def +(arg)
    #   to_s + arg.to_s
    # end
    # 
    # def to_param
    #   @value.id.to_s if @value
    # end
    
    # Returns escaped string from the object's to_s method
    # def to_s
    #   @value ? ERB::Util::h(@value.to_s) : ''
    # end

    # Build or modify @namespace for Representation object 
    # def current_namespace(namespace = nil)
    #   case namespace
    #   when Symbol
    #     @namespace << namespace
    #   when String
    #     @namespace += namespace.split("/").map(&:intern)
    #   when Array
    #     @namespace += namespace
    #   end
    # end

    # #returns html label tag for the representation
    # def label(value = nil, html_options = {})
    #   tree = get_parents_tree
    #   for_attr_value = tree.collect{ |x| x[0] }.join('_')
    #   tags = get_tags(html_options, {:for => for_attr_value})
    #   value = ERB::Util::h(@name.humanize) if value.nil?
    #   %Q{<label #{tags}>#{value}</label>}
    # end
    # 
    # def _html_field_name
    #   return @name unless @parent
    #   "#{@parent._html_field_name}[#{_nested_html_field_name}]"
    # end
    # 
    # def _is_has_one_relation(name)
    #   false
    # end
    # 
    # protected
    # #Call the passed block (if any) 
    # def with_block(&block)
    #   yield self if block_given? && @value
    # end
    # #Returns two dimensional array based on the tree of the Represantation objects which are linked together by the @parent field
    # #First element of the array consists of Representation's @name and the second of Representation's class
    # def get_parents_tree
    #   tree = Array.new
    #   tree[0] = []
    #   tree[0][0] = @name
    #   tree[0][1] = self.class
    #   parent = @parent
    #   while parent do #iterate parent tree
    #     array = []
    #     array[0] = parent.instance_variable_get(:@name)
    #     array[1] = parent.class
    #     tree.unshift(array)
    #     parent = parent.instance_variable_get(:@parent)
    #   end
    #   tree #tree now looks something like this [['user', ActiverRecordRepresentation], ['nick', DefaultRepresentation]]
    # end
    # #Creates value of the html name attribute according to the passed tree 
    # def get_html_name_attribute_value(tree)
    #   first = tree.delete_at(0)
    #   root_name = first[0]
    #   name = []
    #   prev = nil
    #   tree.each do |elem| 
    #     if elem[1] == DefaultRepresentation || elem[1] == TimeWithZoneRepresentation || prev == AssociationsRepresentation
    #       name.push "[#{elem[0]}]"
    #     else
    #       name.push "[#{elem[0]}_attributes]"
    #     end
    #     prev = elem[1]
    #   end
    #   name.unshift(root_name)
    # end
    # #Returns string created by merging two hashes of html options passed as the arguments
    # def get_tags(user_options, base_options)
    #   options = base_options.merge(user_options)
    #   options.stringify_keys!
    #   options = options.sort
    #   options.map{ |key, value| %(#{key}="#{value}") }.join(" ")
    # end
    # 
    # def _nested_html_field_name
    #   "#{@name}_attributes"
    # end
  end
end
