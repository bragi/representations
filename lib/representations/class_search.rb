module Representations
  # Defines policy on representations naming
  class ClassSearch
    # Returns (and when required loads or creates) a representation class for
    # given object.
    #
    # Following class names are tried (class is object.class.to_s):
    #  * classRepresentation - for user-defined classes (AR derrived for example)
    #  * Representations::class - for standard classes
    def class_for(object)
      object_class = object.class.to_s
      # Try to load user-defined representation
      representation_class = "#{object_class}Representation".constantize rescue nil
      # Try to use standard representation
      representation_class ||= "Representations::#{object_class}".constantize rescue nil
      # We need to create representation class for this object
      # ActiveRecord derrived classes use different base
      representation_class ||= begin
        base = object.is_a?(::ActiveRecord::Base) ? ::Representations::ActiveRecord : ::Representations::Default
        name = "::#{object_class}Representation"
        eval("class #{name} < #{base}; end; #{name}")
      end
    end
  end
end