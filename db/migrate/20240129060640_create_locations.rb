class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :name, index: true
      t.string :latitude
      t.string :longitude
      t.integer :aqi_average

      t.timestamps
    end
  end
end
