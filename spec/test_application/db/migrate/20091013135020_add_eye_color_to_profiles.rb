class AddEyeColorToProfiles < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.references :eye_color
    end
  end

  def self.down
    change_table :profiles do |t|
      t.remove :eye_color
    end
  end
end
