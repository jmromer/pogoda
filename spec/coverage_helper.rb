# frozen_string_literal: true

# Code Coverage
# -------------
# - Enabled by default
# - set COVERAGE env var to false to disable
# - open coverage/index.html to view reports
# - set PRINT_COVERAGE env var to print report to stdout instead

return unless ENV.fetch("COVERAGE", true).to_bool

require "simplecov"
require "simplecov-console"

SimpleCov.formatter = SimpleCov::Formatter::Console if ENV["PRINT_COVERAGE"].to_bool
SimpleCov.start("rails") do
  add_filter %r{app/.+/application_.+\.rb}
  add_filter %r{app/controllers/(devise|users)/.+}
  add_filter "app/controllers/home_controller.rb"
  add_filter "app/channels/application_cable/channel.rb"
  add_filter "app/channels/application_cable/connection.rb"
  add_filter "app/helpers/glyphicon_helper.rb"
  add_filter "app/jobs/"
end
