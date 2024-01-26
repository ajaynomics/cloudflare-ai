require "test_helper"

class Cloudflare::AI::Results::AutomaticSpeechRecognitionTest < Minitest::Test
  def setup
    @result = Cloudflare::AI::Results::AutomaticSpeechRecognition.new(successful_response_json)
  end

  def test_successful_result
    assert @result.success?
    refute @result.failure?

    assert_equal successful_response_json["result"]["text"], @result.text
    assert_equal successful_response_json["result"]["word_count"], @result.word_count
    assert_equal successful_response_json["result"]["words"], @result.words
  end

  def test_to_json
    assert_equal successful_response_json.to_json, @result.to_json
  end

  private

  def successful_response_json
    {
      result: {
        text: "It is a good day",
        word_count: 5,
        words: [
          {
            word: "It",
            start: 0.5600000023841858,
            end: 1
          },
          {
            word: "is",
            start: 1,
            end: 1.100000023841858
          },
          {
            word: "a",
            start: 1.100000023841858,
            end: 1.2200000286102295
          },
          {
            word: "good",
            start: 1.2200000286102295,
            end: 1.3200000524520874
          },
          {
            word: "day",
            start: 1.3200000524520874,
            end: 1.4600000381469727
          }
        ]
      },
      success: true,
      errors: [],
      messages: []
    }.deep_stringify_keys
  end
end
