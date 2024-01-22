module Cloudflare
  module AI
    module Clients
      module TestHelpers
        def setup
          @account_id = "fake-account-id"
          @api_token = "fake-api-key"
          @model_name = "fake-model-name"

          @client = Cloudflare::AI::Client.new(account_id: @account_id, api_token: @api_token)
          @url = set_service_url_for_model(@model_name)
        end

        private

        def set_service_url_for_model(model_name)
          @url = @client.send(:service_url_for, account_id: @account_id, model_name: model_name)
        end

        def stub_successful_request
          stub_request(:post, @url).to_return(status: 200, body: {success: true}.to_json)
        end

        def stub_unsuccessful_request
          stub_request(:post, @url)
            .to_return(status: 200, body: {success: false, errors: [{code: 10000, message: "Some error"}]}.to_json)
        end
      end
    end
  end
end
