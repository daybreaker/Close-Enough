class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :location
      t.string :flyer
    end
  end
end
