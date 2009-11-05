module Representations
  #unused
  module ControllerHelpers
    def uses_representations(hash)
      raise 'Ambigouse options' if hash.keys.size > 1
      raise 'Automatic wrapping is disabled' unless Representations.automatic_wrapping
      @use_r_for = hash[:only] rescue actions.collect{|a| a if hash[:except].include?(a).compact}
    end
  end
end
