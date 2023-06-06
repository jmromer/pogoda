# frozen_string_literal: true

require "vcr"

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir = Rails.root.join("spec/fixtures/cassettes")
  config.configure_rspec_metadata!
  config.debug_logger = $stdout if ENV["DEBUG_VCR"].to_bool
  config.hook_into(:webmock)
  config.ignore_localhost = true

  config.default_cassette_options = {
    record: :new_episodes,
    match_requests_on: %i[method host path],
  }

  # Filter sensitive data
  # https://relishapp.com/vcr/vcr/v/6-0-0/docs/configuration/filter-sensitive-data
  config.before_record do |interaction|
    interaction.response.headers.delete("Set-Cookie")
    interaction.request.headers.delete("Authorization")
    interaction.request.headers.delete("X-Stripe-Client-User-Agent")
  end
end
