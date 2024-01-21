require "event_stream_parser"
require "faraday"

class Cloudflare::AI::Client
  attr_reader :url, :account_id, :api_token

  def initialize(account_id:, api_token:)
    @account_id = account_id
    @api_token = api_token
  end

  def chat(messages:, model_name: default_model_name, &block)
    url = service_url_for(account_id: account_id, model_name: model_name)
    stream = block ? true : false
    payload = create_payload({messages: messages.map(&:serializable_hash)}, stream: stream)
    post_request(url, payload, &block)
  end

  def complete(prompt:, model_name: default_model_name, &block)
    url = service_url_for(account_id: account_id, model_name: model_name)
    stream = block ? true : false
    payload = create_payload({prompt: prompt}, stream: stream)
    post_request(url, payload, &block)
  end

  private

  def default_model_name
    Cloudflare::AI::Models.text_generation.first
  end

  def create_payload(data, stream: false)
    data.merge({stream: stream}).to_json
  end

  def post_request(url, payload, &block)
    if block
      parser = EventStreamParser::Parser.new
      connection.post(url, payload) do |response|
        response.options.on_data = parser.stream do |_type, data, _id, _reconnection_time, _size|
          yield data
        end
      end
    else
      Cloudflare::AI::Result.new(connection.post(url, payload).body)
    end
  end

  def connection
    @connection ||= ::Faraday.new(headers: {Authorization: "Bearer #{api_token}"})
  end

  def service_url_for(account_id:, model_name:)
    "https://api.cloudflare.com/client/v4/accounts/#{account_id}/ai/run/#{model_name}"
  end
end
