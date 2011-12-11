class CreateDigestedNameForLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :digested_name, :string
  end

  def self.down
    remove_column :locations, :digested_name
  end
end
