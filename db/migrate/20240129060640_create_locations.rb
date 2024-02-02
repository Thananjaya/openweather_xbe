class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :city, index: true
      t.string :state, index: true
      t.string :latitude
      t.string :longitude
      t.integer :aqi_average

      t.timestamps
    end
  end
end
