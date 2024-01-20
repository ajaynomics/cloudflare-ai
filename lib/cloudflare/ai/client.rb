require "faraday"

class Cloudflare::AI::Client
  attr_reader :url, :account_id, :api_token

  def initialize(account_id:, api_token:)
    @account_id = account_id
    @api_token = api_token
  end

  def complete(prompt:, model_name: models[:text_generation].first)
    url = service_url_for(account_id: account_id, model_name: model_name)

    Cloudflare::AI::Result.new(connection.post(url, {prompt:}.to_json).body)
  end

  def chat(messages:, model_name: models[:text_generation].first)
    url = service_url_for(account_id: account_id, model_name: model_name)

    Cloudflare::AI::Result.new(connection.post(url, {messages:}.to_json).body)
  end

  def models
    {
      text_generation: %w[@cf/meta/llama-2-7b-chat-fp16 @cf/meta/llama-2-7b-chat-int8 @cf/mistral/mistral-7b-instruct-v0.1 @hf/thebloke/codellama-7b-instruct-awq],
      speech_recognition: %w[@cf/openai/whisper],
      translation: %w[@cf/meta/m2m100-1.2b],
      text_classification: %w[@cf/huggingface/distilbert-sst-2-int8],
      image_classification: %w[@cf/huggingface/distilbert-sst-2-int8],
      text_to_image: %w[@cf/stabilityai/stable-diffusion-xl-base-1.0],
      text_embeddings: %w[@cf/baai/bge-base-en-v1.5 @cf/baai/bge-large-en-v1.5 @cf/baai/bge-small-en-v1.5]
    }.freeze
  end

  private

  def connection
    @connection ||= ::Faraday.new(headers: {Authorization: "Bearer #{api_token}"})
  end

  def service_url_for(account_id:, model_name:)
    "https://api.cloudflare.com/client/v4/accounts/#{account_id}/ai/run/#{model_name}"
  end
end
