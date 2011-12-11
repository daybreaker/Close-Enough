class AddFieldsToLocations < ActiveRecord::Migration
  def self.up
    add_column :events, :band_name, :string
    add_column :events, :location_id, :integer

  end

  def self.down
    remove_column :events, :band_name
    remove_column :events, :location_id
  end
end
