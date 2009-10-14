class AddCharecteristicsToProfile < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.text :characteristics
    end
  end

  def self.down
    change_table :profiles do |t|
      t.remove :characteristics
    end
  end
end
