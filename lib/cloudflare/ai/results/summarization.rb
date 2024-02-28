class Cloudflare::AI::Results::Summarization < Cloudflare::AI::Result
  def summary
    result&.dig(:summary) # nil if no response
  end
end
