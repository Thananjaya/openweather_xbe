class Location < ApplicationRecord
	has_many :pollution_variables, dependent: :destroy

	after_create :save_average_aqi

	def self.save_average_aqi
		Openweather.new('http://api.openweathermap.org/data/2.5/air_pollution/history?lat=28.7041&lon=77.1025&start=1690614323&end=1706511863&appid=699c61e67d8661a88790e8a50fec331d').fetch_average_aqi
	end
end
