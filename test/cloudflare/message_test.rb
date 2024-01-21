require "test_helper"

class Cloudflare::AI::MessageTest < Minitest::Test
  def test_validation_of_roles
    message = system_message_fixture(content: nil)
    valid_roles = %w[system user assistant]

    valid_roles.each do |role|
      message.role = role
      message.validate
      assert message.errors[:role].blank?
    end

    message.role = "invalid"
    message.validate
    assert_equal [{error: :inclusion, value: message.role}], message.errors.details[:role]
  end

  def test_validation_of_content
    message = system_message_fixture(content: nil)
    message.validate
    assert_equal [{error: :blank}], message.errors.details[:content]
  end

  def test_to_json
    message = system_message_fixture(content: "Hello")
    assert_equal({role: "system", content: "Hello"}.to_json, message.to_json)
  end

  private

  def system_message_fixture(content: "Hello")
    Cloudflare::AI::Message.new(role: "system", content: content)
  end

  def user_message_fixture(content: "Hello")
    Cloudflare::AI::Message.new(role: "user", content: content)
  end
end
