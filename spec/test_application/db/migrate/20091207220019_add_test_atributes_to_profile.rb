class AddTestAtributesToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :maried, :boolean #to check check_box 
    add_column :profiles, :picture, :string #to check file_field
    add_column :profiles, :hidden_value, :string #to check hidden_field
    add_column :profiles, :password, :string #to check password_field
  end

  def self.down
    remove_column :profiles, :maried
    remove_column :profiles, :picture
    remove_column :profiles, :hidden_value
    remove_column :profiles, :password
  end
end
