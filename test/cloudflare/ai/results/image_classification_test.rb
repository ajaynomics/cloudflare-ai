require "test_helper"

class Cloudflare::AI::Results::ImageClassificationTest < Minitest::Test
  def setup
    @result = Cloudflare::AI::Results::ImageClassification.new(successful_response_json)
  end

  def test_successful_result
    assert @result.success?
    refute @result.failure?

    assert_equal successful_response_json["result"], @result.result
  end

  def test_to_json
    assert_equal successful_response_json.to_json, @result.to_json
  end

  private

  def successful_response_json
    {
      result: [{label: "PERSIAN CAT", score: 0.4071170687675476}, {label: "PEKINESE", score: 0.23444877564907074}],
      success: true,
      errors: [],
      messages: []
    }.deep_stringify_keys
  end
end
