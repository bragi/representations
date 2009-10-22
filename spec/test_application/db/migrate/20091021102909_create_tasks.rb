class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :title
      t.date :due_to
      t.text :description
      t.integer :priority
    end
  end

  def self.down
    drop_table :tasks
  end
end
