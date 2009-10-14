class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.string :name
      t.text :surname
      t.belongs_to :user
      t.string :eye_color
    end
  end

  def self.down
    drop_table :profiles
  end
end
