require "test_helper"

class Cloudflare::AI::ResultTest < Minitest::Test
  def test_successful_result
    result = Cloudflare::AI::Result.new(successful_response_json)
    assert result.success?
    refute result.failure?

    assert_equal successful_response_json["result"]["response"], result.response
  end

  def test_unsuccessful_result
    result = Cloudflare::AI::Result.new(unsuccessful_response_json)
    refute result.success?
    assert result.failure?

    assert_equal unsuccessful_response_json["errors"][0]["code"], result.errors[0]["code"]
    assert_equal unsuccessful_response_json["errors"][0]["message"], result.errors[0]["message"]
  end

  def test_to_json
    result = Cloudflare::AI::Result.new(successful_response_json)
    assert_equal successful_response_json.to_json, result.to_json
  end

  private

  def successful_response_json
    {
      "result" => {
        "response" => "Happy song"
      },
      "success" => true
    }
  end

  def unsuccessful_response_json
    {
      "errors" => [{
        "code" => 10000,
        "message" => "Some error"
      }],
      "success" => false
    }
  end
end
