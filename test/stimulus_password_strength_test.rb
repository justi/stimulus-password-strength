# frozen_string_literal: true

require "test_helper"

class StimulusPasswordStrengthTest < Minitest::Test
  def test_has_version
    refute_nil ::StimulusPasswordStrength::VERSION
  end

  def test_default_require_path_compatibility
    require "stimulus/password/strength"
    assert_respond_to ::StimulusPasswordStrength, :configure
  end

  def test_configuration_defaults
    config = StimulusPasswordStrength.configuration
    assert_equal "space-y-1", config.container_class
    assert_equal "#f87171", config.bar_colors[:weak]
    assert_equal "#ef4444", config.text_colors[:weak]
    assert_equal "#22c55e", config.bar_colors[:good]
    assert_equal "min-width: 2.5rem; text-align: right; white-space: nowrap;", config.text_style
    assert_equal "min-height: 1rem;", config.status_row_style
    assert_equal "min-height: 1rem;", config.requirements_style
    assert_equal "color: #6b7280;", config.requirement_pending_style
  end
end
