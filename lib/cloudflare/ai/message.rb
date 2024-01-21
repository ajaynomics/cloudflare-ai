require "active_model"

class Cloudflare::AI::Message
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  attr_accessor :role, :content

  validates_inclusion_of :role, in: %w[system user assistant]
  validates_presence_of :content

  def initialize(role:, content:)
    @role = role
    @content = content
  end

  def attributes
    {role: role, content: content}
  end
end
