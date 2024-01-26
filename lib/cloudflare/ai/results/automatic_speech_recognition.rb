class Cloudflare::AI::Results::AutomaticSpeechRecognition < Cloudflare::AI::Result
  def text
    result&.dig(:text) # nil if no shape
  end

  def word_count
    result&.dig(:word_count) # nil if no shape
  end

  def words
    result&.dig(:words) # nil if no shape
  end
end
