class CreatePollutionVariables < ActiveRecord::Migration[7.1]
  def change
    create_table :pollution_variables do |t|
      t.integer :aqi
      t.jsonb :pollutant_concentrations
      t.string :measured_time
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
