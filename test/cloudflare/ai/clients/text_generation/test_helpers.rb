module Cloudflare
  module AI
    module Clients
      module TextGeneration
        module TestHelpers
          private

          def default_model_name
            Cloudflare::AI::Models.text_generation.first
          end
        end
      end
    end
  end
end
