class PollutionDataExtractionJob < ApplicationJob
	def perform(location_id, uri)
		count = 0
		aqi_value = 0
		location = Location.find(location_id)
		Openweather.new(uri).fetch_data['list'].each do |data|
			location.pollution_variables.create!(
				aqi: data['main']['aqi'],
				pollutant_concentrations: data['components'],
				measured_at: Time.at(data['dt']).to_s
			)
			count += 1
			aqi_value += data['main']['aqi']
		end
		location.update(aqi_average: aqi_value/count)
	end
end
