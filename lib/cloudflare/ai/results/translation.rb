class Cloudflare::AI::Results::Translation < Cloudflare::AI::Result
  def translated_text
    result&.dig(:translated_text) # nil if no shape
  end
end
