class Cloudflare::AI::Models
  class << self
    def text_generation
      %w[@hf/thebloke/llamaguard-7b-awq @hf/thebloke/neural-chat-7b-v3-1-awq @cf/meta/llama-2-7b-chat-fp16 @cf/mistral/mistral-7b-instruct-v0.1 @hf/thebloke/codellama-7b-instruct-awq @cf/meta/llama-2-7b-chat-int8 @hf/thebloke/mistral-7b-instruct-v0.1-awq @hf/thebloke/deepseek-coder-6.7b-base-awq @hf/thebloke/openhermes-2.5-mistral-7b-awq @hf/thebloke/deepseek-coder-6.7b-instruct-awq @hf/thebloke/zephyr-7b-beta-awq]
    end

    def automatic_speech_recognition
      %w[@cf/openai/whisper]
    end

    def translation
      %w[@cf/meta/m2m100-1.2b]
    end

    def text_classification
      %w[@cf/huggingface/distilbert-sst-2-int8]
    end

    def image_classification
      %w[@cf/microsoft/resnet-50]
    end

    def text_to_image
      %w[@cf/stabilityai/stable-diffusion-xl-base-1.0]
    end

    def text_embedding
      %w[@cf/baai/bge-base-en-v1.5 @cf/baai/bge-large-en-v1.5 @cf/baai/bge-small-en-v1.5]
    end

    def all
      {
        text_generation: text_generation,
        automatic_speech_recognition: automatic_speech_recognition,
        translation: translation,
        text_classification: text_classification,
        image_classification: image_classification,
        text_to_image: text_to_image,
        text_embeddings: text_embedding
      }
    end
  end
end
