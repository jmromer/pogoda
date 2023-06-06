# frozen_string_literal: true

# A JSON parser for HTTParty Responses
#
# Parses any JSON objects into ActiveSupport::HashWithIndifferentAccess objects
# instead of plain Hash objects.
class IndifferentAccessParser < HTTParty::Parser
  SupportedFormats["application/json"] = :json
  SupportedFormats["text/json"] = :json

  protected

  def json
    @json ||= indifferent_access(JSON.parse(body))
  rescue JSON::ParserError
    super
  end

  def indifferent_access(object)
    case object
    when Hash
      object.with_indifferent_access
    when Array
      object.map { |e| indifferent_access(e) }
    else
      object
    end
  end
end
