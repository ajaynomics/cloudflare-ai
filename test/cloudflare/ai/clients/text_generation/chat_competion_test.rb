require "test_helper"
require_relative "../test_helpers"
require_relative "test_helpers"

module Cloudflare::AI::Clients
  module TextGeneration
    class ChatCompletionTest < Minitest::Test
      include Cloudflare::AI::Clients::TestHelpers
      include Cloudflare::AI::Clients::TextGeneration::TestHelpers

      def test_successful_request
        stub_successful_request
        response = @client.chat(messages: messages_fixture, model_name: @model_name, max_tokens: @max_tokens)

        assert response.is_a? Cloudflare::AI::Results::TextGeneration
        assert response.success?
      end

      def test_unsuccessful_request
        stub_unsuccessful_request
        response = @client.chat(messages: messages_fixture, model_name: @model_name, max_tokens: @max_tokens)

        assert response.is_a? Cloudflare::AI::Results::TextGeneration
        assert response.failure?
      end

      def test_uses_default_model_if_not_provided
        model_name = Cloudflare::AI::Models.text_generation.first
        @url = @client.send(:service_url_for, account_id: @account_id, model_name: model_name)

        stub_successful_request
        assert @client.chat(messages: messages_fixture) # Webmock will raise an error if the request was to wrong model
      end

      def test_max_tokens_default_if_not_set
        stub_successful_request

        received_payload = nil

        Faraday::Connection.stub_any_instance(:post, ->(_, payload) {
                                                       received_payload = payload
                                                       OpenStruct.new(body: {}.to_json)
                                                     }) do
          @client.chat(messages: messages_fixture, model_name: @model_name) # Webmock will raise an error if the request was to wrong model
        end

        assert_equal @client.send(:default_max_tokens), JSON.parse(received_payload)["max_tokens"]
      end

      def test_handle_streaming_from_cloudflare_to_client_if_block_given
        set_service_url_for_model(Cloudflare::AI::Models.text_generation.last)
        stub_successful_request

        inner_streaming_response_from_cloudflare_handled = false
        outer_streaming_response_relayed = false

        EventStreamParser::Parser.stub_any_instance(:stream, -> { inner_streaming_response_from_cloudflare_handled = true }) do
          @client.send(:connection).stub(:post, ->(*_, &block) {
            %w[data_chunk].map { OpenStruct.new(options: OpenStruct.new(on_data: "dummy_proc")) }.each { |chunk| block.call(chunk, chunk.bytesize) }
            outer_streaming_response_relayed = true
          }) do
            @client.chat(messages: messages_fixture) { |data| puts data }
          end
        end

        assert inner_streaming_response_from_cloudflare_handled
        assert outer_streaming_response_relayed
      end

      private

      def messages_fixture
        [
          Cloudflare::AI::Message.new(role: "system", content: "This is a system message"),
          Cloudflare::AI::Message.new(role: "assistant", content: "This is an assistant message"),
          Cloudflare::AI::Message.new(role: "user", content: "This is a user message")
        ]
      end
    end
  end
end
