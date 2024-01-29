class Openweather
	def initialize(url)
		@openweather_api = url
	end

	def fetch_aqi
		fetch_data['list'].first['main']['aqi']
	end

	def fetch_average_aqi
		count = 0
		aqi_value = 0
		fetch_data['list'].each do |data|
			count += 1
			aqi_value += data['main']['aqi']
		end
		aqi_value/count
	end

	def fetch_data
		uri = URI(@openweather_api)
		res = Net::HTTP.get_response(uri)
		JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
	end
end