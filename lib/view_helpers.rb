module Representations
    module ViewHelpers
        def r(model)
            r = Representations.representation_for(model, self, find_variables_name(model))
            yield r if block_given?
            r
        end
        private
        def find_variables_name(object)
            self.instance_variables.each do |name|
                return name[1..-1] if instance_variable_get(name) == object
            end
        end
    end
end
