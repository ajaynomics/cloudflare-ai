require "test_helper"
require_relative "test_helpers"

module Cloudflare::AI::Clients
  class AutomaticSpeechRecognitionTest < Minitest::Test
    include Cloudflare::AI::Clients::TestHelpers

    def setup
      super
      @audio_path = "test/fixtures/files/Fanfare60.wav"
      @source_url = "https://example.com/Fanfare60.wav"
    end

    def test_successful_request_with_source_url_input
      stub_request(:get, "https://example.com/Fanfare60.wav").to_return(status: 200, body: "", headers: {})
      stub_successful_request

      response = @client.transcribe(source_url: @source_url, model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::AutomaticSpeechRecognition
      assert response.success?
    end

    def test_successful_request_with_file_input
      stub_successful_request
      response = @client.transcribe(audio: File.open(@audio_path), model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::AutomaticSpeechRecognition
      assert response.success?
    end

    def test_unsuccessful_request
      stub_unsuccessful_request
      response = @client.transcribe(audio: File.open(@audio_path), model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::AutomaticSpeechRecognition
      assert response.failure?
    end

    def test_uses_default_model_if_not_provided
      model_name = Cloudflare::AI::Models.automatic_speech_recognition.first
      @url = @client.send(:service_url_for, account_id: @account_id, model_name: model_name)

      stub_successful_request
      assert @client.transcribe(audio: File.open(@audio_path)) # Webmock will raise an error if the request was to wrong model
    end

    private

    def default_model_name
      Cloudflare::AI::Models.automatic_speech_recognition.first
    end
  end
end
