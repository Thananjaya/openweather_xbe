class Openweather
	def initialize(url)
		@openweather_api = url
	end

	def fetch_aqi
		fetch_data['list'].first['main']['aqi']
	end

	def fetch_data
		uri = URI(@openweather_api)
		res = Net::HTTP.get_response(uri)
		JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
	end
end