# frozen_string_literal: true

module WeatherAPI
  class Response
    attr_reader :payload,
                :location,
                :coordinates,
                :current,
                :current_temp,
                :current_condition,
                :current_condition_icon_url

    def initialize(payload = {})
      @payload = payload
      @location = payload[:location].slice(:name, :region, :country).values.join(", ")
      @coordinates = payload[:location].slice(:lat, :lon).values
      @current = payload[:current]
      @current_temp = current[:temp_f]
      @current_condition = current.dig(:condition, :text)
      @current_condition_icon_url = current.dig(:condition, :icon)
    end

    def days
      @days ||=
        payload
          .dig(:forecast, :forecastday)
          .map { Forecast.new(_1) }
          .sort
    end

    class Forecast
      include Comparable

      attr_reader :payload, :date, :daily, :min, :max, :chance_of_rain

      def initialize(payload = {})
        @payload = payload
        @date = payload[:date].to_date
        @daily = payload[:day]
        @min = daily[:mintemp_f]
        @max = daily[:maxtemp_f]
        @chance_of_rain = daily[:daily_chance_of_rain]
      end

      def condition
        daily.dig(:condition, :text)
      end

      def condition_icon_url
        daily.dig(:condition, :icon)
      end

      def <=>(other)
        date <=> other.date
      end
    end
  end
end
