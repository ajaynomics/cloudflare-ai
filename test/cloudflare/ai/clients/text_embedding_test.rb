require "test_helper"
require_relative "test_helpers"

module Cloudflare::AI::Clients
  class TextEmbeddiingTest < Minitest::Test
    include Cloudflare::AI::Clients::TestHelpers

    def test_successful_request_with_string_input
      stub_response_for_successful_embedding_of_string
      response = @client.embed(text: "hello", model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::TextEmbedding
      assert response.success?
    end

    def test_successful_request_with_array_input
      stub_response_for_successful_embedding_of_array
      response = @client.embed(text: ["hello", "jello"], model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::TextEmbedding
      assert response.success?
    end

    def test_unsuccessful_request
      stub_response_for_unsuccessful_completion
      response = @client.embed(text: "hello", model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::TextEmbedding
      assert response.failure?
    end

    def test_uses_default_model_if_not_provided
      model_name = Cloudflare::AI::Models.text_embedding.first
      @url = @client.send(:service_url_for, account_id: @account_id, model_name: model_name)

      stub_response_for_successful_embedding_of_string
      assert @client.embed(text: "hello") # Webmock will raise an error if the request was to wrong model
    end

    private

    def stub_response_for_successful_embedding_of_string
      stub_request(:post, @url)
        .to_return(status: 200, body: {result: {shape: [1, 4], data: [0.1, 0.2, 0.3, 0.4]}, success: true}.to_json)
    end

    def stub_response_for_successful_embedding_of_array
      stub_request(:post, @url)
        .to_return(status: 200, body: {result: {shape: [2, 4], data: [[0.1, 0.2, 0.3, 0.4], [0.1, 0.2, 0.3, 0.4]]}, success: true}.to_json)
    end

    def default_model_name
      Cloudflare::AI::Models.text_embedding.first
    end
  end
end
