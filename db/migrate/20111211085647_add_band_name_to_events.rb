class AddBandNameToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :band_name, :string
  end

  def self.down
    remove_column :events, :band_name
  end
end
