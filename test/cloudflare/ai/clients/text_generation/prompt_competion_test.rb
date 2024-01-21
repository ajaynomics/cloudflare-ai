require "test_helper"
require_relative "../test_helpers"
require_relative "test_helpers"

module Cloudflare::AI::Clients
  module TextGeneration
    class PromptCompletionTest < Minitest::Test
      include Cloudflare::AI::Clients::TestHelpers
      include Cloudflare::AI::Clients::TextGeneration::TestHelpers

      def test_successful_request
        stub_response_for_successful_completion
        response = @client.complete(prompt: "Happy song", model_name: @model_name)

        assert response.is_a? Cloudflare::AI::Result
        assert response.success?
      end

      def test_unsuccessful_request
        stub_response_for_unsuccessful_completion
        response = @client.complete(prompt: "Happy song", model_name: @model_name)

        assert response.is_a? Cloudflare::AI::Result
        assert response.failure?
      end

      def test_uses_default_model_if_not_provided
        set_service_url_for_model(default_model_name)
        stub_response_for_successful_completion

        assert @client.complete(prompt: "Happy song") # Webmock will raise an error if the request was to wrong model
      end

      def test_handle_streaming_from_cloudflare_to_client_if_block_given
        set_service_url_for_model(default_model_name)
        stub_response_for_successful_completion

        inner_streaming_data_received_from_cloudflare = false
        outer_streaming_data_relayed_to_client_block = false

        EventStreamParser::Parser.stub_any_instance(:stream, -> { inner_streaming_data_received_from_cloudflare = true }) do
          @client.send(:connection).stub(:post, ->(*_, &block) {
                                                  %w[data_chunk].map { OpenStruct.new(options: OpenStruct.new(on_data: "dummy_proc")) }.each { |chunk| block.call(chunk, chunk.bytesize) }
                                                  outer_streaming_data_relayed_to_client_block = true
                                                }) do
            @client.complete(prompt: "Happy song") { |data| puts data }
          end
        end

        assert inner_streaming_data_received_from_cloudflare
        assert outer_streaming_data_relayed_to_client_block
      end
    end
  end
end
