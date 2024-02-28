class Cloudflare::AI::Models
  class << self
    def all
      {
        automatic_speech_recognition: automatic_speech_recognition,
        image_classification: image_classification,
        image_to_text: image_to_text,
        object_detection: object_detection,
        summarization: summarization,
        text_classification: text_classification,
        text_embeddings: text_embedding,
        text_generation: text_generation,
        text_to_image: text_to_image,
        translation: translation
      }
    end

    def automatic_speech_recognition
      %w[@cf/openai/whisper]
    end

    def image_classification
      %w[@cf/microsoft/resnet-50]
    end

    def image_to_text
      %w[@cf/unum/uform-gen2-qwen-500m]
    end

    def object_detection
      %w[@cf/meta/det-resnet-50]
    end

    def summarization
      %w[@cf/facebook/bart-large-cnn]
    end

    def text_classification
      %w[@cf/huggingface/distilbert-sst-2-int8]
    end

    def text_embedding
      %w[@cf/baai/bge-base-en-v1.5 @cf/baai/bge-large-en-v1.5 @cf/baai/bge-small-en-v1.5]
    end

    def text_generation
      %w[
        @hf/thebloke/codellama-7b-instruct-awq
        @hf/thebloke/deepseek-coder-6.7b-base-awq
        @hf/thebloke/deepseek-coder-6.7b-instruct-awq
        @cf/deepseek-ai/deepseek-math-7b-base
        @cf/deepseek-ai/deepseek-math-7b-instruct
        @cf/thebloke/discolm-german-7b-v1-awq
        @cf/tiiuae/falcon-7b-instruct
        @hf/thebloke/llama-2-13b-chat-awq
        @cf/meta/llama-2-7b-chat-fp16
        @cf/meta/llama-2-7b-chat-int8
        @hf/thebloke/llamaguard-7b-awq
        @cf/mistral/mistral-7b-instruct-v0.1
        @hf/thebloke/mistral-7b-instruct-v0.1-awq
        @hf/thebloke/neural-chat-7b-v3-1-awq
        @hf/thebloke/openchat_3.5-awq
        @cf/openchat/openchat-3.5-0106
        @hf/thebloke/openhermes-2.5-mistral-7b-awq
        @cf/microsoft/phi-2
        @cf/qwen/qwen1.5-0.5b-chat
        @cf/qwen/qwen1.5-1.8b-chat
        @cf/qwen/qwen1.5-14b-chat-awq
        @cf/qwen/qwen1.5-7b-chat-awq
        @cf/defog/sqlcoder-7b-2
        @cf/tinyllama/tinyllama-1.1b-chat-v1.0
        @hf/thebloke/zephyr-7b-beta-awq
      ]
    end

    def text_to_image
      %w[
        @cf/lykon/dreamshaper-8-lcm
        @cf/runwayml/stable-diffusion-v1-5-img2img
        @cf/runwayml/stable-diffusion-v1-5-inpainting
        @cf/stabilityai/stable-diffusion-xl-base-1.0
        @cf/bytedance/stable-diffusion-xl-lightning
      ]
    end

    def translation
      %w[@cf/meta/m2m100-1.2b]
    end
  end
end
