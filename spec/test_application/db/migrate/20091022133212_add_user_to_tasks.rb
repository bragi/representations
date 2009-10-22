class AddUserToTasks < ActiveRecord::Migration
  def self.up
    change_table :tasks do |t|
      t.belongs_to :user
    end
  end

  def self.down
    change_table :tasks do |t|
      t.remove :user
    end
  end
end
