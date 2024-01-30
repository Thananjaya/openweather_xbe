# frozen_string_literal: true

# Model methods for 'location' records
class Location < ApplicationRecord
  has_many :pollution_variables, dependent: :destroy

  after_create :extract_pollution_variables

  validates_uniqueness_of :city, case_sensitive: false

  def extract_pollution_variables
    PollutionDataExtractionJob.perform_later(id)
  end

  def save_pollution_variable(data)
    pollution_variable = pollution_variables.new(
      aqi: data['main']['aqi'],
      pollutant_concentrations: data['components'],
      measured_at: Time.at(data['dt']).to_s
    )
    if pollution_variable.save && update(aqi_average: (pollution_variables.sum(:aqi) / pollution_variables.count))
      { success: true, location: json_data, current_pollution_status: pollution_variable.json_data }
    end
  end

  def json_data
    {
      city: city,
      state: state,
      latitude: latitude,
      longitude: longitude,
      aqi_average: aqi_average ? aqi_average : 'Yet to be measured',
      average_aqi_quality: aqi_average ? PollutionVariable::AQI_QUALITY[aqi_average] : 'Yet to be measured'
    }
  end
end
