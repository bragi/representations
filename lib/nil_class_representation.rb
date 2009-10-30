module Representations
  #Representation for objects which are nil
  class NilClassRepresentation < Representation
    #Returns self so the calls:
    #nil_object.not_defined_method.another_not_defined_method
    #want raise an error
    def method_missing(method_name, *args)
      return self
    end
    #Passed block shouldn't be called
    def with_block(&block)
    end
    #Returns blank string
    def to_s
      return ''
    end
  end
end
