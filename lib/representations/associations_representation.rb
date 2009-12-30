module Representations
  #Representation for Collections
  class AssociationsRepresentation < Representation
    #initilize @num variable
    def initialize(object, template, name, parent)
      super
      @num = -1 #-1 so first call to num will result in 0
    end
    #Creates Representation for every object in the Array and invokes passed block with this Representation as the argument
    def each
      raise "You must supply a block" unless block_given?
      @value.each_index do |idx|
        representation_object = Representations.representation_for(@value[idx], @template, idx.to_s, self)
        #add to page hidden input with id of the object in the collection
        tree = representation_object.get_parents_tree
        name = get_html_name_attribute_value(tree)
        name << '[id]'
        tags = get_tags({}, {:value => @value[idx].id.to_s, :name => name.join})
        @template.concat("<input type='hidden' #{tags}/>")
        yield representation_object
      end
    end
    #Creates new object in the collection and input fields for it defined in the passed block 
    def build
      new_object = @value.build 
      representation_object = AssociationsRepresentation::NewRecordRepresentation.new(new_object, @template, 'new_' + num.to_s, self)
      yield representation_object if block_given?
      representation_object
    end

    private 

      attr_reader :num
      #Used for generating unique @name for ArrayRepresentation::NewRecordRepresentation
      def num
        @num += 1 
      end
    #Representation that wraps newly created ActiveRecord::Base that will be added to some collection
    class NewRecordRepresentation < Representation
      #Creates new method which wraps call for ActionRecord
      #New method returns Representation which represents datatype in the appropriate column
      def method_missing(method_name_symbol, *args, &block)
        method_name = method_name_symbol.to_s
        representation_class = case @value.class.columns_hash[method_name].type
                               when :date 
                                 Representations::DateRepresentation
                               when :datetime 
                                 Representations::DateRepresentation
                               else
                                 Representations::DefaultRepresentation
                               end
        method = <<-EOF
          def #{method_name}(*args, &block)
             @__#{method_name} ||= #{representation_class}.new(@value.#{method_name}, @template, "#{method_name}", self)
             @__#{method_name}.with_block(&block)
             @__#{method_name} if block.nil?
          end
        EOF
        ::Representations::AssociationsRepresentation::NewRecordRepresentation.class_eval(method, __FILE__, __LINE__)
        self.__send__(method_name_symbol, &block)
      end

      def _nested_html_field_name
        @name
      end
    end
  end
end
