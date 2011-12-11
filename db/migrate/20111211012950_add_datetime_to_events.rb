class AddDatetimeToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :start, :datetime
    add_column :events, :end, :datetime
  end

  def self.down
    remove_column :events, :start
    remove_column :events, :end
  end
end
