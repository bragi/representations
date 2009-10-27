module Representations
    module ViewHelpers
        def r(model)
            r = Representations.representation_for(model, self, model.class.to_s.downcase)
            yield r if block_given?
            r
        end
    end
end
