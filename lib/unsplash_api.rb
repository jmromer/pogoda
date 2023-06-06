# frozen_string_literal: true

class UnsplashAPI
  include HTTParty

  parser IndifferentAccessParser
  debug_output if ENV["DEBUG_REQUESTS"].to_bool
  base_uri "api.unsplash.com"

  ACCESS_KEY = Rails.application.credentials.unsplash_access_key
  SECRET_KEY = Rails.application.credentials.unsplash_secret_key

  attr_reader :version, :access_key, :secret_key, :headers

  def initialize(version: 1, access_key: nil, secret_key: nil)
    @version = "v#{version}"
    @access_key = access_key || ACCESS_KEY
    @secret_key = secret_key || SECRET_KEY
    @headers = {
      "Accept-Version" => self.version,
      "Authorization" => "Client-ID #{self.access_key}",
    }
  end

  def random_search(query)
    return if query.blank?

    query = { query: query, page: rand(1..50), per_page: 10 }
    resp = self.class.get("/search/photos", query: query, headers: headers)
    return unless resp.code == 200

    resp.parsed_response[:results].sample.dig(:urls, :regular)
  end
end
