require "test_helper"
require_relative "../test_helpers"
require_relative "test_helpers"

module Cloudflare::AI::Clients
  module TextGeneration
    class ChatCompletionTest < Minitest::Test
      include Cloudflare::AI::Clients::TestHelpers
      include Cloudflare::AI::Clients::TextGeneration::TestHelpers

      def test_successful_request
        stub_response_for_successful_completion
        response = @client.chat(messages: messages_fixture, model_name: @model_name)

        assert response.is_a? Cloudflare::AI::Result
        assert response.success?
      end

      def test_unsuccessful_request
        stub_response_for_unsuccessful_completion
        response = @client.chat(messages: messages_fixture, model_name: @model_name)

        assert response.is_a? Cloudflare::AI::Result
        assert response.failure?
      end

      def test_uses_default_model_if_not_provided
        model_name = @client.models[:text_generation].first # defaults to first in list
        @url = @client.send(:service_url_for, account_id: @account_id, model_name: model_name)

        stub_response_for_successful_completion
        assert @client.chat(messages: messages_fixture) # Webmock will raise an error if the request was to wrong model
      end

      def test_streaming_output_defaults_to_false
        stream_value = nil
        @client.send(:connection).stub(:post, ->(_, payload) {
                                                connection = OpenStruct.new(body: payload)
                                                stream_value = JSON.parse(connection.body)["stream"]
                                                connection
                                              }) do
          @client.chat(messages: messages_fixture, model_name: @model_name)
        end

        assert stream_value == false
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
