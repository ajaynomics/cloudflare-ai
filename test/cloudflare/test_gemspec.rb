require "test_helper"

class Cloudflare::AI::TestGemspec < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Cloudflare::AI::VERSION
  end
end
