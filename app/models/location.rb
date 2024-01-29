class Location < ApplicationRecord
	has_many :pollution_variables, dependent: :destroy

	after_create :save_pollution_variables

	validates_uniqueness_of :name, case_sensitive: false

	def save_pollution_variables
		uri = "http://api.openweathermap.org/data/2.5/air_pollution/history?lat=#{latitude}&lon=#{longitude}&start=#{3.months.ago.to_i}&end=#{DateTime.now.to_i}&appid=699c61e67d8661a88790e8a50fec331d"
		PollutionDataExtractionJob.perform_later(id, uri)
	end
end
