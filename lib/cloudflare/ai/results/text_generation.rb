class Cloudflare::AI::Results::TextGeneration < Cloudflare::AI::Result
  def response
    result&.dig(:response) # nil if no response
  end
end
