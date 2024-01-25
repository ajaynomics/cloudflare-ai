require "test_helper"

class Cloudflare::AI::Results::TextToImageTest < Minitest::Test
  def setup
    @tempfile = Tempfile.new
    @result = Cloudflare::AI::Results::TextToImage.new(@tempfile)
  end

  def test_successful_result
    assert @result.success?
    refute @result.failure?

    assert_equal @tempfile, @result.result
  end

  def test_to_json
    assert_equal successful_response_json.to_json, @result.to_json
  end

  private

  def successful_response_json
    {
      result: @tempfile,
      success: true,
      errors: [],
      messages: []
    }.deep_stringify_keys
  end
end
