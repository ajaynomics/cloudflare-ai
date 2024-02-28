require "test_helper"

class Cloudflare::AI::Results::SummarizationTest < Minitest::Test
  def setup
    @result = Cloudflare::AI::Results::Summarization.new(successful_response_json)
  end

  def test_successful_result
    assert @result.success?
    refute @result.failure?

    assert_equal successful_response_json["result"]["summary"], @result.summary
  end

  def test_to_json
    assert_equal successful_response_json.to_json, @result.to_json
  end

  private

  def successful_response_json
    {result: {summary: "Happy song"}, success: true, errors: [], messages: []}.deep_stringify_keys
  end
end
