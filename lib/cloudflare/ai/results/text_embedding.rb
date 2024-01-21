class Cloudflare::AI::Results::TextEmbedding < Cloudflare::AI::Result
  def shape
    result&.dig(:shape) # nil if no shape
  end

  def data
    result&.dig(:data) # nil if no data
  end
end
