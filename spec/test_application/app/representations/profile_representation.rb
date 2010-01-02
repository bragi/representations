class ProfileRepresentation < Representations::ActiveRecord
  def name_with_smile
    name + ' :)'
  end
end
