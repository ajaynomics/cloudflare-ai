require "test_helper"

class Cloudflare::AI::Results::TextEmbeddingTest < Minitest::Test
  def test_successful_result
    result = Cloudflare::AI::Results::TextEmbedding.new(successful_response_json)
    assert result.success?
    refute result.failure?

    assert_equal successful_response_json["result"]["shape"], result.shape
    assert_equal successful_response_json["result"]["data"], result.data
  end

  def test_to_json
    result = Cloudflare::AI::Results::TextEmbedding.new(successful_response_json)
    assert_equal successful_response_json.to_json, result.to_json
  end

  private

  def successful_response_json
    {result:
       {shape: [1, 4],
        data: [[-0.008496830239892006, 0.001376907923258841, -0.0323275662958622, 0.019507134333252907]]},
     success: true,
     errors: [],
     messages: []}.deep_stringify_keys
  end
end
