class AddFieldsToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :status, :string
    add_column :locations, :from_wwoz, :integer
  end

  def self.down
    remove_column :locations, :status
    remove_column :locations, :from_wwoz
  end
end
