class CreateEyeColors < ActiveRecord::Migration
  def self.up
    create_table :eye_colors do |t|
      t.string :color
    end
  end

  def self.down
    drop_table :eye_colors
  end
end
