# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @query = params[:query]
    @condition_image_url = ENV.fetch("DEFAULT_CONDITION_IMAGE_URL", nil)
    return if @query.blank?

    @forecast = get_forecast(@query)
    @condition_image_url = UnsplashAPI.new.random_search(@forecast&.current_condition)
    @location = @forecast&.location
  end

  private

  def get_forecast(query)
    cache_key = [:forecast, query]
    forecast = Rails.cache.read(cache_key)

    if forecast.present?
      @cached_forecast = true
      return forecast
    end

    @cached_forecast = false
    Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      WeatherAPI::Client.new.forecast(query, days: 5)
    end
  end
end
