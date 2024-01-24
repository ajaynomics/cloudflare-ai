require "test_helper"

class Cloudflare::AI::Results::TextGenerationTest < Minitest::Test
  def setup
    @result = Cloudflare::AI::Results::TextGeneration.new(successful_response_json)
  end

  def test_successful_result
    assert @result.success?
    refute @result.failure?

    assert_equal successful_response_json["result"]["response"], @result.response
  end

  def test_to_json
    assert_equal successful_response_json.to_json, @result.to_json
  end

  private

  def successful_response_json
    {result: {response: "Happy song"}, success: true, errors: [], messages: []}.deep_stringify_keys
  end
end
