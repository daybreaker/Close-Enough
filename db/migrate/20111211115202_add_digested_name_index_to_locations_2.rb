class AddDigestedNameIndexToLocations2 < ActiveRecord::Migration
  def self.up
    add_index :locations, :digested_name
  end

  def self.down
    remove_index :locations, :digested_name
  end
end
