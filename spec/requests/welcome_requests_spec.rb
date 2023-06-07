# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Welcome" do
  describe "#index" do
    it "responds with the forecast template" do
      get "/"
      expect(response).to have_http_status(:ok)
      expect(response.body).to match(/loading 5-day forecast.../)
    end

    it "responds with a weather forecast if provided a valid query",
       vcr: { cassette_name: :weather_api_by_us_zip } do
      get "/", params: { query: "90210" }
      expect(response).to have_http_status(:ok)
      expect(response.body).to match(/Beverly Hills, California/)
      expect(response.body).to match(/Sunny/)
    end
  end
end
