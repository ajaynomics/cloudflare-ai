require "test_helper"
require_relative "test_helpers"

module Cloudflare::AI::Clients
  class TranslationTest < Minitest::Test
    include Cloudflare::AI::Clients::TestHelpers

    def test_successful_request
      stub_successful_request
      response = @client.translate(text: "hello", source_lang: "en", target_lang: "es", model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::Translation
      assert response.success?
    end

    def test_unsuccessful_request
      stub_unsuccessful_request
      response = @client.translate(text: "hello", source_lang: "en", target_lang: "es", model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::Translation
      assert response.failure?
    end

    def test_uses_default_model_if_not_provided
      model_name = Cloudflare::AI::Models.translation.first
      @url = @client.send(:service_url_for, account_id: @account_id, model_name: model_name)

      stub_successful_request
      assert @client.translate(text: "hello", source_lang: "en", target_lang: "es") # Webmock will raise an error if the request was to wrong model
    end

    def test_uses_en_as_source_lang_if_not_provided
      stub_successful_request

      received_payload = nil

      Faraday::Connection.stub_any_instance(:post, ->(_, payload) {
        received_payload = payload
        OpenStruct.new(body: {}.to_json)
      }) do
        @client.translate(text: "Hello Jello", target_lang: "es", model_name: @model_name) # Webmock will raise an error if the request was to wrong model
      end

      assert_equal "en", JSON.parse(received_payload)["source_lang"]
    end

    private

    def default_model_name
      Cloudflare::AI::Models.text_embedding.first
    end
  end
end
