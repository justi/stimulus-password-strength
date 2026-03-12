# frozen_string_literal: true

require "test_helper"
require "action_view/test_case"

class PasswordStrengthFieldRenderTest < ActionView::TestCase
  tests StimulusPasswordStrength::Helper

  def teardown
    I18n.locale = I18n.default_locale
  end

  def test_renders_password_field_markup_for_stimulus
    render inline: render_template(label: "Password", requirements: [min_length_requirement])

    assert_includes rendered, 'data-controller="password-strength"'
    assert_includes rendered, 'data-password-strength-target="input"'
    assert_includes rendered, 'data-password-strength-target="strengthBar"'
    assert_includes rendered, 'data-password-strength-target="requirement"'
    assert_includes rendered, 'data-rule="min_length"'
    assert_includes rendered, 'data-value="12"'
    assert_includes rendered, 'Type %{count} more characters'
    assert_includes rendered, 'aria-label="Show"'
  end

  def test_uses_i18n_labels_by_default
    I18n.locale = :pl

    render inline: render_template(label: "Hasło", requirements: [min_length_requirement])

    assert_includes rendered, 'data-password-strength-weak-label="Słabe"'
    assert_includes rendered, 'data-password-strength-good-label="Dobre"'
    assert_includes rendered, 'aria-label="Pokaż"'
    assert_includes rendered, 'title="Pokaż"'
  end

  def test_raises_for_unsupported_requirement_rule
    error = assert_raises(ActionView::Template::Error) do
      render inline: render_template(label: "Password", requirements: [{ rule: :number, label: "Add a number" }])
    end

    assert_equal "Unsupported requirement rule: number", error.cause.message
  end

  private

  def render_template(label:, requirements:)
    <<~ERB
      <%= form_with scope: :user, url: "/users", local: true do |form| %>
        <%= password_strength_field form, :password, label: #{label.inspect}, requirements: #{requirements.inspect} %>
      <% end %>
    ERB
  end

  def min_length_requirement
    {
      rule: :min_length,
      value: 12,
      label: "At least 12 characters",
      remaining_singular: "Type 1 more character",
      remaining_plural: "Type %{count} more characters",
      met_label: "12+ chars"
    }
  end
end
