# frozen_string_literal: true

require_relative "../integration_test_helper"

class DummyAppSmokeTest < ActionDispatch::IntegrationTest
  test "preview route renders password strength field" do
    get "/preview"

    assert_response :success
    assert_includes response.body, 'data-controller="password-strength"'
    assert_includes response.body, 'data-password-strength-target="input"'
    assert_includes response.body, 'data-password-strength-target="requirement"'
    assert_includes response.body, 'data-password-strength-target="strengthBar"'
    assert_includes response.body, "At least 12 characters"
    assert_includes response.body, 'aria-label="Show"'
  end
end
