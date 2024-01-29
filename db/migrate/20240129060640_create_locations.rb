class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :lattitude
      t.string :longitude
      t.integer :aqi_average

      t.timestamps
    end
  end
end
