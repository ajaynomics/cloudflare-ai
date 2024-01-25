require "test_helper"
require_relative "test_helpers"

module Cloudflare::AI::Clients
  class TextToImageTest < Minitest::Test
    include Cloudflare::AI::Clients::TestHelpers

    def setup
      super
    end

    def test_successful_request
      stub_successful_request
      response = @client.draw(prompt: "Draw this", model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::TextToImage
      assert response.success?
    end

    def test_uses_default_model_if_not_provided
      model_name = Cloudflare::AI::Models.text_to_image.first
      @url = @client.send(:service_url_for, account_id: @account_id, model_name: model_name)

      stub_successful_request
      assert @client.draw(prompt: "Which model?") # Webmock will raise an error if the request was to wrong model
    end

    private

    def default_model_name
      Cloudflare::AI::Models.image_classification.first
    end
  end
end
