require "test_helper"
require_relative "test_helpers"

module Cloudflare::AI::Clients
  class TextEmbeddingTest < Minitest::Test
    include Cloudflare::AI::Clients::TestHelpers

    def test_successful_request_with_string_input
      stub_successful_request
      response = @client.embed(text: "hello", model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::TextEmbedding
      assert response.success?
    end

    def test_successful_request_with_array_input
      stub_successful_request
      response = @client.embed(text: ["hello", "jello"], model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::TextEmbedding
      assert response.success?
    end

    def test_unsuccessful_request
      stub_unsuccessful_request
      response = @client.embed(text: "hello", model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::TextEmbedding
      assert response.failure?
    end

    def test_uses_default_model_if_not_provided
      model_name = Cloudflare::AI::Models.text_embedding.first
      @url = @client.send(:service_url_for, account_id: @account_id, model_name: model_name)

      stub_successful_request
      assert @client.embed(text: "hello") # Webmock will raise an error if the request was to wrong model
    end

    private

    def default_model_name
      Cloudflare::AI::Models.text_embedding.first
    end
  end
end
