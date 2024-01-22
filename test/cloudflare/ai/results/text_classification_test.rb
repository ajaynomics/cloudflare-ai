require "test_helper"

class Cloudflare::AI::Results::TextClassificationTest < Minitest::Test
  def test_successful_result
    result = Cloudflare::AI::Results::TextClassification.new(successful_response_json)
    assert result.success?
    refute result.failure?

    assert_equal successful_response_json["result"], result.result
  end

  def test_to_json
    result = Cloudflare::AI::Results::TextClassification.new(successful_response_json)
    assert_equal successful_response_json.to_json, result.to_json
  end

  private

  def successful_response_json
    {
      result: [{label: "positive", score: 0.9999998807907104}, {label: "negative", score: 1.1920928955078125e-7}],
      success: true,
      errors: [],
      messages: []
    }.deep_stringify_keys
  end
end
