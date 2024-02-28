require "test_helper"
require_relative "test_helpers"

module Cloudflare::AI::Clients
  class SummarizationTest < Minitest::Test
    include Cloudflare::AI::Clients::TestHelpers

    def test_successful_request
      stub_successful_request
      response = @client.summarize(text: "This should be a long piece of text.", model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::Summarization
      assert response.success?
    end

    def test_unsuccessful_request
      stub_unsuccessful_request
      response = @client.summarize(text: "This won't work", model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::Summarization
      assert response.failure?
    end

    def test_uses_default_model_if_not_provided
      model_name = Cloudflare::AI::Models.summarization.first
      @url = @client.send(:service_url_for, account_id: @account_id, model_name: model_name)

      stub_successful_request
      assert @client.summarize(text: "This will run with the default model") # Webmock will raise an error if the request was to wrong model
    end

    def test_max_tokens_default_if_not_set
      stub_successful_request

      received_payload = nil

      Faraday::Connection.stub_any_instance(:post, ->(_, payload) {
        received_payload = payload
        OpenStruct.new(body: {}.to_json)
      }) do
        @client.summarize(text: "Summarize me", model_name: @model_name) # Webmock will raise an error if the request was to wrong model
      end

      assert_equal default_max_tokens, JSON.parse(received_payload)["max_tokens"]
    end

    private

    def default_model_name
      Cloudflare::AI::Models.summarization.first
    end

    def default_max_tokens
      1024
    end
  end
end
