# frozen_string_literal: true

require "rails_helper"

RSpec.describe WeatherAPI do
  describe "#forecast" do
    it "returns a forecast object for the given location, searching by US zip",
       vcr: { cassette_name: :weather_api_by_us_zip } do
      resp = described_class.new.forecast("90210")
      expect(resp).to be_present
    end

    it "returns a forecast object for the given location, searching by city name",
       vcr: { cassette_name: :weather_api_by_city_name } do
      resp = described_class.new.forecast("Paris, France")
      expect(resp).to be_present
    end

    it "returns a forecast object for the given location, searching by coordinates",
       vcr: { cassette_name: :weather_api_by_coordinates } do
      resp = described_class.new.forecast("48.8567,2.3508")
      expect(resp).to be_present
    end

    it "raises an error if auth is unsuccessful", vcr: { cassette_name: :weather_api_auth_failure } do
      expect { described_class.new(key: "bad-key").forecast("New York City") }
        .to raise_error(WeatherAPI::Error, /API key has been disabled/)
    end

    it "returns an empty object if the given location is not found",
       vcr: { cassette_name: :weather_api_location_not_found } do
      resp = described_class.new.forecast("Svenborgia")
      expect(resp).to be_nil
    end
  end
end
