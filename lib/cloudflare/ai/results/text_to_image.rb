class Cloudflare::AI::Results::TextToImage < Cloudflare::AI::Result
  def initialize(file)
    @result_data = {result: file, success: true, errors: [], messages: []}
  end
end
