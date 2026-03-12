# frozen_string_literal: true

require "test_helper"
require "rails/generators/test_case"
require "generators/stimulus_password_strength/install/install_generator"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests StimulusPasswordStrength::Generators::InstallGenerator
  destination File.expand_path("../tmp/generator_destination", __dir__)

  setup :prepare_destination

  def setup
    super
    write_file "config/importmap.rb", "# importmap\n"
    write_file "app/javascript/controllers/index.js", <<~JS
      import { application } from "./application"
    JS
  end

  def test_install_generator_creates_required_files_and_registrations
    run_generator

    assert_file "config/importmap.rb" do |content|
      assert_includes content, 'pin "stimulus-password-strength", to: "stimulus_password_strength_controller.js", preload: false'
      assert_includes content, 'pin "zxcvbn", to: "zxcvbn.js", preload: false'
    end

    assert_file "app/javascript/controllers/index.js" do |content|
      assert_includes content, 'import PasswordStrengthController from "stimulus-password-strength"'
      assert_includes content, 'application.register("password-strength", PasswordStrengthController)'
    end

    assert_file "config/initializers/stimulus_password_strength.rb"
    assert_file "app/lib/password_policy.rb" do |content|
      assert_includes content, "MIN_LENGTH = 12"
      assert_includes content, 'remaining_plural: "Type %{count} more characters"'
    end
  end

  def test_install_generator_is_idempotent
    run_generator
    run_generator

    importmap = File.read(File.join(destination_root, "config/importmap.rb"))
    index = File.read(File.join(destination_root, "app/javascript/controllers/index.js"))

    assert_equal 1, importmap.scan('pin "stimulus-password-strength", to: "stimulus_password_strength_controller.js", preload: false').size
    assert_equal 1, importmap.scan('pin "zxcvbn", to: "zxcvbn.js", preload: false').size
    assert_equal 1, index.scan('import PasswordStrengthController from "stimulus-password-strength"').size
    assert_equal 1, index.scan('application.register("password-strength", PasswordStrengthController)').size
  end

  private

  def write_file(path, content)
    absolute_path = File.join(destination_root, path)
    FileUtils.mkdir_p(File.dirname(absolute_path))
    File.write(absolute_path, content)
  end
end
