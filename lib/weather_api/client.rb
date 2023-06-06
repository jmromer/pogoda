# frozen_string_literal: true

module WeatherAPI
  class Client
    include HTTParty
    include ResponseStub if ENV["STUB_REQUESTS"].to_bool

    parser IndifferentAccessParser
    debug_output if ENV["DEBUG_REQUESTS"].to_bool
    base_uri "api.weatherapi.com"

    API_KEY = Rails.application.credentials.weather_api_key

    attr_reader :options, :version, :format

    def initialize(key: nil, version: 1, format: :json)
      @options = { key: key || API_KEY }
      @version = "v#{version}"
      @format = format
    end

    # keyword args:
    #
    # query: Requested location, in one of the following formats.
    #
    #   - latitude and longitude (decimal degree), eg: q=48.8567,2.3508
    #   - city name, eg: q=Paris
    #   - US zip, eg: q=10001
    #   - UK postcode, eg: q=SW1
    #   - Canada postal code, eg: q=G2J
    #   - metar:<metar code>, eg: q=metar:EGLL
    #   - iata:<3 digit airport code>, eg: q=iata:DXB
    #   - auto:ip IP lookup, eg: q=auto:ip
    #   - IP address (IPv4 and IPv6 supported), eg: q=100.0.0.1
    #
    # days: Number of days of forecast required.
    #       - between 1 and 14. e.g: days=5
    #       - If no days parameter is provided then only today's weather is returned.
    #
    def forecast(query, days: nil)
      return if query.blank?
      return WeatherAPI::Response.new(response_body) if ENV["STUB_REQUESTS"].to_bool

      self.class
        .get("/#{version}/forecast.#{format}", query: { **options, q: query, days: days }.compact)
        .then { handle_response(_1) }
        .then { WeatherAPI::Response.new(_1) if _1 }
    end

    private

    def handle_response(resp)
      case resp.code
      when 400 # {"error"=>{"code"=>1006, "message"=>"No matching location found."}}
      when (401...500) # {"error"=>{"code"=>1002, "message"=>"API key is invalid or not provided."}}
        raise AuthenticationError, resp.parsed_response.dig(:error, :message)
      when (200...300)
        resp.parsed_response
      else
        raise Error, resp.parsed_response
      end
    end

    class Error < StandardError; end
    class AuthenticationError < Error; end
  end
end
