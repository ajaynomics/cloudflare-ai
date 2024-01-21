module Cloudflare
  module AI
    module Clients
      module TextGenerationHelpers
        def default_text_generation_model_name
          Cloudflare::AI::Models.text_generation.first
        end

        def create_streamable_payload(data, stream: false)
          data.merge({stream: stream}).to_json
        end

        def post_streamable_request(url, payload, &block)
          if block
            parser = EventStreamParser::Parser.new
            connection.post(url, payload) do |response|
              response.options.on_data = parser.stream do |_type, data, _id, _reconnection_time, _size|
                yield data
              end
            end
          else
            Cloudflare::AI::Results::TextGeneration.new(connection.post(url, payload).body)
          end
        end
      end
    end
  end
end
