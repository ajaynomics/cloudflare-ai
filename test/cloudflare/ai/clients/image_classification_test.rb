require "test_helper"
require_relative "test_helpers"

module Cloudflare::AI::Clients
  class ImageClassificationTest < Minitest::Test
    include Cloudflare::AI::Clients::TestHelpers

    def setup
      super
      @image_path = "test/fixtures/files/robot.jpg"
    end

    def test_successful_request_with_string_input
      stub_successful_request
      response = @client.classify(image: @image_path, model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::ImageClassification
      assert response.success?
    end

    def test_successful_request_with_file_io_input
      stub_successful_request
      response = @client.classify(image: File.open(@image_path), model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::ImageClassification
      assert response.success?
    end

    def test_unsuccessful_request
      stub_unsuccessful_request
      response = @client.classify(image: @image_path, model_name: @model_name)

      assert response.is_a? Cloudflare::AI::Results::ImageClassification
      assert response.failure?
    end

    def test_uses_default_model_if_not_provided
      model_name = Cloudflare::AI::Models.image_classification.first
      @url = @client.send(:service_url_for, account_id: @account_id, model_name: model_name)

      stub_successful_request
      assert @client.classify(image: @image_path) # Webmock will raise an error if the request was to wrong model
    end

    private

    def default_model_name
      Cloudflare::AI::Models.image_classification.first
    end
  end
end
