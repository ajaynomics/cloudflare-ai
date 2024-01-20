# frozen_string_literal: true

require_relative "ai/version"
require "logger"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "ai" => "AI"
)
loader.push_dir("#{__dir__}/", namespace: Cloudflare)
loader.setup

module Cloudflare
  module AI
    class << self
      attr_reader :logger, :root

      def logger=(logger)
        @logger = ContextualLogger.new(logger)
      end
    end

    self.logger ||= ::Logger.new($stdout, level: :debug)

    @root = Pathname.new(__dir__)

    class Error < StandardError; end
    # Your code goes here...
  end
end
