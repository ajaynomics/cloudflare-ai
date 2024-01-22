Cloudflare Workers AI API client for ruby
---
Cloudflare is testing its [Workers AI](https://blog.cloudflare.com/workers-ai) API. 
Hopefully this project makes it easier for ruby-first developers to consume 
Cloudflare's latest and greatest. 


![Tests status](https://github.com/ajaynomics/cloudflare-ai/actions/workflows/ci.yml/badge.svg?branch=main)
[![Gem Version](https://badge.fury.io/rb/cloudflare-ai.svg)](https://badge.fury.io/rb/cloudflare-ai)
![GitHub License](https://img.shields.io/github/license/ajaynomics/cloudflare-ai)

I'm really interested in applying retrieval-augmented
generation to make legal services more accessible. [Email me](mailto:cloudflare-ai@krishnan.ca).

If you're looking for legal help, it's best to book a slot via https://www.krishnan.ca.

# Todo
It's still early days, and here are my immediate priorities:
* [x] Support for streamed responses
* [x] CI pipeline
* [ ] Support for more AI model categories
  * [x] [Text Generation](https://developers.cloudflare.com/workers-ai/models/text-generation/)
  * [x] [Text Embeddings](https://developers.cloudflare.com/workers-ai/models/text-embeddings/)
  * [ ] [Text Classification](https://developers.cloudflare.com/workers-ai/models/text-classification/)
  * [ ] [Image Classification](https://developers.cloudflare.com/workers-ai/models/image-classification/)
  * [ ] [Translation](https://developers.cloudflare.com/workers-ai/models/translation/)
  * [ ] [Text-to-Image](https://developers.cloudflare.com/workers-ai/models/text-to-image/)
  * [ ] [Automatic Speech Recognition](https://developers.cloudflare.com/workers-ai/models/speech-recognition/)

# Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Logging](#logging)
- [Development](#development)

# Installation

Install the gem and add to the application's Gemfile by executing:

    bundle add cloudflare-ai

If bundler is not being used to manage dependencies, install the gem by executing:

    gem install cloudflare-ai

# Usage

```ruby
require "cloudflare/ai"
```

## Cloudflare Workers AI
Please visit the [Cloudflare Workers AI website](https://developers.cloudflare.com/workers-ai/) for more details.
Thiis gem provides a client that wraps around [Cloudflare's REST API](https://developers.cloudflare.com/workers-ai/get-started/rest-api/).


## Client

```ruby
client = Cloudflare::AI::Client.new(account_id: ENV["CLOUDFLARE_ACCOUNT_ID"], api_token: ENV["CLOUDFLARE_API_TOKEN"])
```

### Model selection
The model name is an optional parameter to every one of the client methods described below.
For example, if an example is documented as 
```ruby
result = client.complete(prompt: "Hello my name is")
```
this is implicitly the same as 
```ruby
result = client.complete(prompt: "Hello my name is", model: "@cf/meta/llama-2-7b-chat-fp16")
```
The full list of supported models is available here: [models.rb](lib/cloudflare/ai/models.rb).
More information is available [in the cloudflare documentation](https://developers.cloudflare.com/workers-ai/models/).
The default model used is the first enumerated model in the applicable set in [models.rb](lib/cloudflare/ai/models.rb).

### Text generation (chat / scoped prompt)
```ruby
messages = [
  Cloudflare::AI::Message.new(role: "system", content: "You are a big fan of Cloudflare and Ruby."),
  Cloudflare::AI::Message.new(role: "user", content: "What is your favourite tech stack?"),
  Cloudflare::AI::Message.new(role: "assistant", content: "I love building with Ruby on Rails and Cloudflare!"),
  Cloudflare::AI::Message.new(role: "user", content: "Really? You like Cloudflare even though there isn't great support for Ruby?"),
]
result = client.chat(messages: messages)
puts result.response # => "Yes, I love Cloudflare!"
```

#### Streaming responses
Responses will be streamed back to the client using Server Side Events (SSE) if a block is passed to the `chat` or `complete` method.
```ruby
result = client.complete(prompt: "Hi!") { |data| puts data}
# {"response":" "}
# {"response":" Hello"}
# {"response":" there"}
# {"response":"!"}
# {"response":""}
# [DONE]

```
#### Result object
All invocations of the `prompt` and `chat` methods return a `Cloudflare::AI::Results::TextGeneration` object. This object's serializable JSON output is
based on the raw response from the Cloudflare API.

```ruby
result = client.complete(prompt: "What is your name?")

# Successful
puts result.response # => "My name is John."
puts result.success? # => true
puts result.failure? # => false
puts result.to_json # => {"result":{"response":"My name is John"},"success":true,"errors":[],"messages":[]}

# Unsuccessful
puts result.response # => nil
puts result.success? # => false
puts result.failure? # => true
puts result.to_json # => {"result":null,"success":false,"errors":[{"code":7009,"message":"Upstream service unavailable"}],"messages":[]}
```


### Text embedding
```ruby
result = client.embed(text: "Hello")
p result.shape # => [1, 768] # (1 embedding, 768 dimensions per embedding)
p result.embedding # => [[-0.008496830239892006, 0.001376907923258841, -0.0323275662958622, ...]]
```

The input can be either a string (as above) or an array of strings:
```ruby
result = client.embed(text: ["Hello", "World"])
```

#### Result object
All invocations of the `embed` methods return a `Cloudflare::AI::Results::TextEmbedding`. 

### Text classification
```ruby
result = client.classify(text: "You meanie!")
p result.result # => [{"label"=>"NEGATIVE", "score"=>0.6647962927818298}, {"label"=>"POSITIVE", "score"=>0.3352036774158478}]
```

#### Result object
All invocations of the `classify` methods return a `Cloudflare::AI::Results::TextClassification`.

# Logging

This gem uses standard logging mechanisms and defaults to `:warn` level. Most messages are at info level, but we will add debug or warn statements as needed.
To show all log messages:

```ruby
Cloudflare::AI.logger.level = :debug
```

You can use this logger as you would the default ruby logger. For example:
```ruby
Cloudflare::AI.logger = Logger.new($stdout)
```
# Development

1. `git clone https://github.com/ajaynomics/cloudflare-ai.git`
2. `bundle exec rake` to ensure that the tests pass and to run standardrb

# Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ajaynomics/cloudflare-ai.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT). A special thanks to the team at [langchainrb](https://github.com/andreibondarev/langchainrb) &ndash; I learnt a lot reading your codebase as I muddled my way through the initial effort.
