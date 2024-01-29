class Location < ApplicationRecord
	has_many :pollution_variables, dependent: :destroy

	after_create :extract_pollution_variables

	validates_uniqueness_of :name, case_sensitive: false

	def extract_pollution_variables
		uri = "http://api.openweathermap.org/data/2.5/air_pollution/history?lat=#{latitude}&lon=#{longitude}&start=#{3.months.ago.to_i}&end=#{DateTime.now.to_i}&appid=699c61e67d8661a88790e8a50fec331d"
		PollutionDataExtractionJob.perform_later(id, uri)
	end

	def save_pollution_variable(data)
		pollution_variable = pollution_variables.new(
			aqi: data['main']['aqi'],
			pollutant_concentrations: data['components'],
			measured_time: data['dt']
		)
		if pollution_variable.save && self.update(aqi_average: (aqi_average + pollution_variable.aqi)/pollution_variables.count)
			return { success: true, location: self, pollution_variable: pollution_variable }
		end
	end
end
