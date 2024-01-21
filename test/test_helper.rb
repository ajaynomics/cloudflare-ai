# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "cloudflare/ai"

require "minitest/autorun"
require "minitest/stub_any_instance"

require "webmock/minitest"
