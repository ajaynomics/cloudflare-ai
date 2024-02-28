require "event_stream_parser"
require "faraday"

class Cloudflare::AI::Client
  include Cloudflare::AI::Clients::MediaHelpers
  include Cloudflare::AI::Clients::TextGenerationHelpers

  attr_reader :url, :account_id, :api_token

  def initialize(account_id:, api_token:)
    @account_id = account_id
    @api_token = api_token
  end

  def chat(messages:, model_name: default_text_generation_model_name, max_tokens: default_max_tokens, &block)
    url = service_url_for(account_id: account_id, model_name: model_name)
    stream = block ? true : false
    payload = create_streamable_payload({messages: messages.map(&:serializable_hash)}, stream: stream, max_tokens: max_tokens)
    post_streamable_request(url, payload, &block)
  end

  def classify(text: nil, image: nil, model_name: nil)
    raise ArgumentError, "Must provide either text or image (and not both)" if [text, image].compact.size != 1

    model_name ||= text ? Cloudflare::AI::Models.text_classification.first : Cloudflare::AI::Models.image_classification.first
    url = service_url_for(account_id: account_id, model_name: model_name)

    if text
      payload = {text: text}.to_json
      Cloudflare::AI::Results::TextClassification.new(connection.post(url, payload).body)
    else
      image = File.open(image) if image.is_a?(String)
      Cloudflare::AI::Results::ImageClassification.new(post_request_with_binary_file(url, image).body)
    end
  end

  def detect_objects(image: nil, model_name: Cloudflare::AI::Models.object_detection.first)
    url = service_url_for(account_id: account_id, model_name: model_name)

    image = File.open(image) if image.is_a?(String)
    Cloudflare::AI::Results::ObjectDetection.new(post_request_with_binary_file(url, image).body)
  end

  def complete(prompt:, model_name: default_text_generation_model_name, max_tokens: default_max_tokens, &block)
    url = service_url_for(account_id: account_id, model_name: model_name)
    stream = block ? true : false
    payload = create_streamable_payload({prompt: prompt}, stream: stream, max_tokens: max_tokens)
    post_streamable_request(url, payload, &block)
  end

  def draw(prompt:, num_steps: 20, model_name: Cloudflare::AI::Models.text_to_image.first)
    url = service_url_for(account_id: account_id, model_name: model_name)
    payload = {prompt: prompt, num_steps: num_steps}.to_json

    result = connection.post(url, payload).body
    binary_data = result.split(",").map(&:to_i).pack("C*")
    Cloudflare::AI::Results::TextToImage.new(
      Tempfile.new(["cloudflare-ai", ".png"], binmode: true).tap { |result| result.write(binary_data) }
    )
  end

  def embed(text:, model_name: Cloudflare::AI::Models.text_embedding.first)
    url = service_url_for(account_id: account_id, model_name: model_name)
    payload = {text: text}.to_json

    Cloudflare::AI::Results::TextEmbedding.new(connection.post(url, payload).body)
  end

  def summarize(text:, model_name: Cloudflare::AI::Models.summarization.first, max_tokens: 1024)
    url = service_url_for(account_id: account_id, model_name: model_name)
    payload = {input_text: text, max_tokens: max_tokens}.to_json

    Cloudflare::AI::Results::Summarization.new(connection.post(url, payload).body)
  end

  def transcribe(source_url: nil, audio: nil, model_name: Cloudflare::AI::Models.automatic_speech_recognition.first)
    raise ArgumentError, "Must provide either audio_url or audio" if [source_url, audio].compact.size != 1

    audio = download_audio(source_url) if source_url

    url = service_url_for(account_id: account_id, model_name: model_name)
    response = post_request_with_binary_file(url, audio)

    Cloudflare::AI::Results::AutomaticSpeechRecognition.new(response.body)
  end

  def translate(text:, target_lang:, source_lang: "en", model_name: Cloudflare::AI::Models.translation.first)
    url = service_url_for(account_id: account_id, model_name: model_name)
    payload = {text: text, target_lang: target_lang, source_lang: source_lang}.to_json
    Cloudflare::AI::Results::Translation.new(connection.post(url, payload).body)
  end

  private

  def connection
    @connection ||= ::Faraday.new(headers: {Authorization: "Bearer #{api_token}"})
  end

  def service_url_for(account_id:, model_name:)
    "https://api.cloudflare.com/client/v4/accounts/#{account_id}/ai/run/#{model_name}"
  end
end
