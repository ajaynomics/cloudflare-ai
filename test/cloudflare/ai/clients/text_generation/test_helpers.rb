module Cloudflare
  module AI
    module Clients
      module TextGeneration
        module TestHelpers
          private

          def stub_response_for_successful_completion(response: "Happy song")
            stub_request(:post, @url)
              .to_return(status: 200, body: {result: {response: response}, success: true}.to_json)
          end

          def stub_response_for_unsuccessful_completion
            stub_request(:post, @url)
              .to_return(status: 200, body: {success: false, errors: [{code: 10000, message: "Some error"}]}.to_json)
          end
        end
      end
    end
  end
end
