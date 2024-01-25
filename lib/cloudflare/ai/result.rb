require "active_support/core_ext/hash/indifferent_access"
require "json"

class Cloudflare::AI::Result
  def initialize(json_string_or_ruby_hash)
    @result_data = parse_data(json_string_or_ruby_hash)
  end

  def result
    result_data[:result]
  end

  def success?
    success == true
  end

  def failure?
    !success?
  end

  def errors
    result_data.dig(:errors)
  end

  def messages
    result_data.dig(:messages)
  end

  def to_json
    result_data.to_json
  end

  protected

  attr_reader :result_data

  def success
    result_data[:success]
  end

  def parse_data(input)
    input = JSON.parse(input) if input.is_a?(String)
    input.with_indifferent_access
  end
end
