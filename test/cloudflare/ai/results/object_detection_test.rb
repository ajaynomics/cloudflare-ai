require "test_helper"

class Cloudflare::AI::Results::ObjectDetectionTest < Minitest::Test
  def setup
    @result = Cloudflare::AI::Results::ObjectDetection.new(successful_response_json)
  end

  def test_successful_result
    assert @result.success?
    refute @result.failure?

    assert_equal successful_response_json["result"], @result.result
    assert_equal successful_response_json.dig("result", 0, "label"), @result.result.first["label"]
  end

  def test_to_json
    assert_equal successful_response_json.to_json, @result.to_json
  end

  private

  def successful_response_json
    {
      result: [
        {label: "cat", score: 0.4071170687675476, box: {xmin: 0, ymin: 0, xmax: 10, ymax: 10}},
        {label: "face", score: 0.22562485933303833, box: {xmin: 15, ymin: 22, xmax: 25, ymax: 35}},
        {label: "car", score: 0.033316344022750854, box: {xmin: 72, ymin: 55, xmax: 95, ymax: 72}}
      ],
      success: true,
      errors: [],
      messages: []
    }.deep_stringify_keys
  end
end
