module Cloudflare
  module AI
    module Clients
      module TestHelpers
        def setup
          @account_id = "fake-account-id"
          @api_token = "fake-api-key"
          @model_name = "fake-model-name"

          @client = Cloudflare::AI::Client.new(account_id: @account_id, api_token: @api_token)
          @url = @client.send(:service_url_for, account_id: @account_id, model_name: @model_name)
        end
      end
    end
  end
end
