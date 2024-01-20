# frozen_string_literal: true

require_relative "lib/cloudflare/ai/version"

Gem::Specification.new do |spec|
  spec.name = "cloudflare-ai"
  spec.version = Cloudflare::Ai::VERSION
  spec.authors = ["Ajay Krishnan"]
  spec.email = ["rubygems@krishnan.ca"]

  spec.summary = "A ruby client for the Cloudflare AI Workers API."
  spec.description = "This opinionated ruby client is intended to make it uncomfortably easy to use LLMs in your projects."
  spec.homepage = "https://github.com/ajaynomics/cloudflare-ai"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ajaynomics/cloudflare-ai"
  spec.metadata["changelog_uri"] = "https://github.com/ajaynomics/cloudflare-ai/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
