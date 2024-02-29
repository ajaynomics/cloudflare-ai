class Cloudflare::AI::Results::ImageToText < Cloudflare::AI::Result
  def description
    result&.dig(:description) # nil if no shape
  end
end
