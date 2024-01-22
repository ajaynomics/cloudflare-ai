require "test_helper"
require_relative "test_helpers"

module Cloudflare::AI::Clients
  class TextClassificationTest < Minitest::Test
    include Cloudflare::AI::Clients::TestHelpers

    def test_successful_request
      stub_successful_response
      response = @client.classify(text: "This is a happy thought", model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::TextClassification
      assert response.success?
    end

    def test_unsuccessful_request
      stub_unsuccessful_response
      response = @client.classify(text: "This won't work", model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::TextClassification
      assert response.failure?
    end

    def test_uses_default_model_if_not_provided
      model_name = Cloudflare::AI::Models.text_classification.first
      @url = @client.send(:service_url_for, account_id: @account_id, model_name: model_name)

      stub_successful_response
      assert @client.classify(text: "This will run with the default model") # Webmock will raise an error if the request was to wrong model
    end

    private

    def stub_successful_response
      stub_request(:post, @url)
        .to_return(status: 200, body: {success: true}.to_json)
    end

    def default_model_name
      Cloudflare::AI::Models.text_embedding.first
    end
  end
end