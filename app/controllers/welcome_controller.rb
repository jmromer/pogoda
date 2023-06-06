# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @query = params[:query]
    @condition_image_url = ENV.fetch("DEFAULT_CONDITION_IMAGE_URL")
    return if @query.blank?

    @forecast = WeatherAPI::Client.new.forecast(@query, days: 5)
    @condition_image_url = UnsplashAPI.new.random(@forecast&.current_condition)
    @location = @forecast&.location
  end
end
