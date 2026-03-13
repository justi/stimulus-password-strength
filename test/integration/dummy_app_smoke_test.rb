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

  test "hostile preview still renders critical inline layout contracts" do
    get "/preview/hostile"

    assert_response :success
    assert_includes response.body, "position: relative;"
    assert_includes response.body, "display: flex; justify-content: space-between; align-items: flex-end; gap: 0.75rem;"
    assert_includes response.body, "position: absolute; right: 0.75rem; top: 50%; transform: translateY(-50%); display: inline-flex; align-items: center; justify-content: center; padding: 0; border: 0; background: transparent; line-height: 0; z-index: 1;"
    assert_includes response.body, "display: inline-block; width: 5.5rem; text-align: right; white-space: nowrap;"
    assert_includes response.body, "position: static !important;"
    assert_includes response.body, "background: hotpink;"
  end
end
