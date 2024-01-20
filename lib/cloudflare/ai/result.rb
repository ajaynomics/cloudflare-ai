require "active_support/core_ext/hash/indifferent_access"

class Cloudflare::AI::Result
  attr_reader :result, :success, :errors, :messages

  def initialize(json)
    @json = JSON.parse(json) if json.is_a?(String)
    @result = @json["result"]
    @success = @json["success"]
    @errors = @json["errors"]
    @messages = @json["messages"]
  end

  def to_json
    @json.to_json
  end

  def failure?
    !success?
  end

  def success?
    success
  end

  def response
    result.with_indifferent_access["response"]
  end
end
