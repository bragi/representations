class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.string :name
      t.text :surname
      t.belongs_to :user
    end
  end

  def self.down
    drop_table :profiles
  end
end
