class DataSchedulerJob < ApplicationJob
  def perform
    Location.all.each do |location|
      data = Openweather.new("http://api.openweathermap.org/data/2.5/air_pollution?lat=#{location.latitude}&lon=#{location.longitude}&appid=699c61e67d8661a88790e8a50fec331d").fetch_data.dig('list').first
      return if location.pollution_variables.find_by(measured_at: Time.at(data['dt']).to_s)

      puts location.save_pollution_variable(data)
    end
  end
end