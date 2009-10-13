class AddCreatedAtAndUpdatedAtToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.timestamps
    end
  end

  def self.down
    change_table :users do |t|
      t.remove 'created_at'
      t.remove 'updated_at'
    end
  end
end
