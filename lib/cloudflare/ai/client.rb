require "event_stream_parser"
require "faraday"

class Cloudflare::AI::Client
  include Cloudflare::AI::Clients::TextGenerationHelpers

  attr_reader :url, :account_id, :api_token

  def initialize(account_id:, api_token:)
    @account_id = account_id
    @api_token = api_token
  end

  def chat(messages:, model_name: default_text_generation_model_name, &block)
    url = service_url_for(account_id: account_id, model_name: model_name)
    stream = block ? true : false
    payload = create_streamable_payload({messages: messages.map(&:serializable_hash)}, stream: stream)
    post_streamable_request(url, payload, &block)
  end

  def complete(prompt:, model_name: default_text_generation_model_name, &block)
    url = service_url_for(account_id: account_id, model_name: model_name)
    stream = block ? true : false
    payload = create_streamable_payload({prompt: prompt}, stream: stream)
    post_streamable_request(url, payload, &block)
  end

  def embed(text:, model_name: Cloudflare::AI::Models.text_embedding.first)
    url = service_url_for(account_id: account_id, model_name: model_name)
    payload = {text: text}.to_json

    Cloudflare::AI::Results::TextEmbedding.new(connection.post(url, payload).body)
  end

  private

  def connection
    @connection ||= ::Faraday.new(headers: {Authorization: "Bearer #{api_token}"})
  end

  def service_url_for(account_id:, model_name:)
    "https://api.cloudflare.com/client/v4/accounts/#{account_id}/ai/run/#{model_name}"
  end
end
