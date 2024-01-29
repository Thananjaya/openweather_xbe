class PollutionVariable < ApplicationRecord
  belongs_to :location
  validates_uniqueness_of :measured_at, scope: :location_id

  AQI_QUALITY = {
    1 => 'good',
    2 => 'fair',
    3 => 'moderate',
    4 => 'poor',
    5 => 'very poor'
  }

  def json_data
    {
      aqi: aqi,
      aqi_quality: PollutionVariable::AQI_QUALITY[aqi],
      pollutant_concentrations: pollutant_concentrations,
      measured_at: measured_at
    }
  end
end
