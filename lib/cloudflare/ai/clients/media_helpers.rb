require "faraday/multipart"

module Cloudflare
  module AI
    module Clients
      module MediaHelpers
        private

        def download_audio(source_url)
          download_result = Faraday.new(source_url).get
          binary_file = Tempfile.new(["cloudflare-ai-automatic-speech-recognition", ".wav"])
          binary_file.binmode
          binary_file.write(download_result.body)
          binary_file.rewind
          binary_file
        end

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
