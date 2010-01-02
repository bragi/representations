module Representations
  module Extensions
    module ActionView
      def wrap_in_representation(object)
        representation = find_representation_for(object)
        yield representation if block_given?
        representation
      end
      
      alias_method :r, :wrap_in_representation
      
      def find_representation_for(object)
        return object if object.is_a? Representations::Base
        template = self
        name = object.class.to_s.underscore
        representation_class = Representations::ClassSearch.new.class_for(object)
        representation_class.new(object, template, name)
      end
      
      def instance_variable_set_with_wrap_in_representation(symbol, object)
        instance_variable_set_without_r(symbol, wrap_in_representation(obj))
      end
    end
  end
end
