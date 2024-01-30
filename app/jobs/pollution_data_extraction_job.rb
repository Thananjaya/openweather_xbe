# frozen_string_literal: true

# Background job, powered by sidekiq, to save AQI histories
class PollutionDataExtractionJob < ApplicationJob

  def perform(location_id)
    count = 0
    aqi_value = 0
    location = Location.find(location_id)
    uri = "http://api.openweathermap.org/data/2.5/air_pollution/history?lat=#{location.latitude}&lon=#{location.longitude}&start=#{3.months.ago.to_i}&end=#{DateTime.now.to_i}&appid=699c61e67d8661a88790e8a50fec331d"
    Openweather.new(uri).fetch_data['list'].each do |data|
      location.pollution_variables.create!(
        aqi: data['main']['aqi'],
        pollutant_concentrations: data['components'],
        measured_at: Time.at(data['dt']).to_s
      )
      count += 1
      aqi_value += data['main']['aqi']
    end
    location.update(aqi_average: aqi_value / count)
  end
end
