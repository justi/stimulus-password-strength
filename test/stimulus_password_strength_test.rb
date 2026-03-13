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
    assert_equal "display: flex; justify-content: space-between; align-items: flex-end; gap: 0.75rem;", config.label_row_style
    assert_equal "display: flex; justify-content: flex-end; align-items: center;", config.header_aux_style
    assert_equal "#f87171", config.bar_colors[:weak]
    assert_equal "#ef4444", config.text_colors[:weak]
    assert_equal "#22c55e", config.bar_colors[:good]
    assert_equal "font-size: 0.75rem; line-height: 1rem; text-align: right;", config.requirement_style
    assert_equal "position: relative;", config.wrapper_style
    assert_equal "position: absolute; right: 0.75rem; top: 50%; transform: translateY(-50%); display: inline-flex; align-items: center; justify-content: center; padding: 0; border: 0; background: transparent; line-height: 0; z-index: 1;", config.toggle_style
    assert_equal "display: inline-block; width: 5.5rem; text-align: right; white-space: nowrap;", config.text_style
    assert_equal "display: flex; flex-direction: row-reverse; align-items: center; justify-content: flex-start; gap: 0.5rem; min-height: 1rem;", config.status_row_style
    assert_equal "display: flex; justify-content: flex-end; align-items: center; gap: 0.5rem; min-height: 1rem;", config.requirements_style
    assert_equal "height: 0.375rem; width: 5rem; overflow: hidden; border-radius: 9999px; background-color: #e5e7eb; visibility: hidden; flex-shrink: 0;", config.bar_track_style
    assert_equal "display: block; height: 100%; border-radius: 9999px; visibility: hidden; transition: width 300ms ease, background-color 300ms ease;", config.bar_style
    assert_equal "color: #6b7280;", config.requirement_pending_style
  end
end
