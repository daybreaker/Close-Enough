class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.integer  :gid
      t.integer  :cid
      t.text  :address_components
      t.string  :formatted_address
      t.string  :icon
      t.string  :formatted_phone_number
      t.float  :lat
      t.float  :lng
      t.string  :name
      t.float  :rating
      t.text  :reference
      t.string  :types
      t.string  :url
      t.string  :vicinity
    end
  end

  def self.down
    drop_table :locations
  end
end
