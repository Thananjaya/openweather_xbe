# frozen_string_literal: true

# Controller holding actions for handling locations and its dependencies
class LocationsController < ApplicationController
  before_action :find_location, except: [:create]

  def create
    data = Openweather.new("http://api.openweathermap.org/geo/1.0/direct?q=#{params[:name]}&limit=1&appid=699c61e67d8661a88790e8a50fec331d").fetch_data.first
    if data.blank?
      return render json: { success: false, errors: 'No data found' }, status: :not_found
    end

    location = Location.new(city: data['name'], state: data['state'], latitude: data['lat'], longitude: data['lon'])
    if location.save
      render json: { success: true, location: location.json_data }, status: :created
    else
      render json: { success: false, errors: location.errors.full_messages }, status: :internal_server_error
    end
  end

  def current_air_pollution_data
    if @location
      data = Openweather.new("http://api.openweathermap.org/data/2.5/air_pollution?lat=#{@location.latitude}&lon=#{@location.longitude}&appid=699c61e67d8661a88790e8a50fec331d").fetch_data.dig('list').first
      if @location.pollution_variables.find_by(measured_at: Time.at(data['dt']).to_s)
        render json: { success: true, location: @location, current_pollution_status: @location.pollution_variables.last.json_data }, status: :ok
      else
        render json: @location.save_pollution_variable(data), status: :created
      end
    else
      render json: { success: false, errors: 'No Data Found' }, status: :not_found
    end
  end

  def air_quality_metrics
    average_aqi_per_month = @location.pollution_variables.where('cast(measured_at as timestamp) between ? and ?', 1.month.ago, DateTime.now)
    average_aqi_per_state = Location.where(state: @location.state).average(:aqi_average)
    render json: {
      data: {
        average_aqi_per_month: average_aqi_per_month.average(:aqi).to_i,
        average_aqi_per_location: @location.aqi_average,
        average_aqi_per_state: average_aqi_per_state
      }
    }
  end

  private

  def find_location
    @location = Location.where('lower(city)=?', params[:name].downcase)&.first
  end
end
