class LocationsController < ApplicationController

	def create
		data = Openweather.new("http://api.openweathermap.org/geo/1.0/direct?q=#{params[:name]}&limit=1&appid=699c61e67d8661a88790e8a50fec331d").fetch_data.first
		location = Location.new(name: data['name'], latitude: data['lat'], longitude: data['lon'])
		if location.save
			render json: { success: true, location: location.to_json(except: :aqi_average) }, status: :created
		else
			render json: { success: false, errors: location.errors.full_messages }, status: :internal_server_error
		end
	end

	def current_air_pollution_data
		location = Location.where('lower(name)=?', params[:name].downcase).first
		if location
			data = Openweather.new("http://api.openweathermap.org/data/2.5/air_pollution?lat=#{location.latitude}&lon=#{location.longitude}&appid=699c61e67d8661a88790e8a50fec331d").fetch_data.dig('list').first
			if location.pollution_variables.find_by(measured_time: data['dt'])
				render json: { success: true, location: location, pollution_variables: location.pollution_variables.last }, status: :ok
			else
				save_pollution_variables(location, data)
			end
		else
			create
		end
	end

	private

	def save_pollution_variables(location, data)
		pollution_variables = location.pollution_variables.new(
			aqi: data['main']['aqi'],
			pollutant_concentrations: data['components'],
			measured_time: data['dt']
		)
		if pollution_variables.save
			render json: { success: true, location: location, pollution_variables: pollution_variables }, status: :created
		else
			render json: { success: false, errors: pollution_variables.errors.full_messages }, status: :internal_server_error
		end
	end
end