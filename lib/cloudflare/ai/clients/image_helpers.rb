require "faraday/multipart"

module Cloudflare
  module AI
    module Clients
      module ImageHelpers
        private

        def post_request_with_binary_file(url, file)
          connection.post do |req|
            req.url url
            req.headers["Transfer-Encoding"] = "chunked"
            req.headers["Content-Type"] = "multipart/form-data"
            req.body = ::Faraday::UploadIO.new(file, "octet/stream")
          end
        end
      end
    end
  end
end
