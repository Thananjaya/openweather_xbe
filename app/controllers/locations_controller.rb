class LocationsController < ApplicationController

	def create
		data = Openweather.new('http://api.openweathermap.org/geo/1.0/direct?q=chennai&limit=1&appid=699c61e67d8661a88790e8a50fec331d').fetch_data
		location = Location.new(name: data['name'], latitude: data['latitude'], longitude: data['longitude'])
		if location.save
			render json: {success: true, location: location}, status: :created
		else
			render json: {success: false, errors: location.errors.full_messages}, status: :internal_server_error
		end
	end
end