# frozen_string_literal: true

module StimulusPasswordStrength
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def add_importmap_pins
        importmap_path = "config/importmap.rb"
        return unless destination_file?(importmap_path)

        add_pin(importmap_path, 'pin "stimulus-password-strength", to: "stimulus_password_strength_controller.js", preload: false')
        add_pin(importmap_path, 'pin "zxcvbn", to: "zxcvbn.js", preload: false')
      end

      def register_stimulus_controller
        index_path = "app/javascript/controllers/index.js"
        return unless destination_file?(index_path)

        content = read_destination(index_path)
        import_line = 'import PasswordStrengthController from "stimulus-password-strength"'
        register_line = 'application.register("password-strength", PasswordStrengthController)'

        append_to_file(index_path, "\n#{import_line}\n") unless content.include?(import_line)
        append_to_file(index_path, "#{register_line}\n") unless read_destination(index_path).include?(register_line)
      end

      def create_initializer
        template "stimulus_password_strength.rb.tt", "config/initializers/stimulus_password_strength.rb"
      end

      def create_password_policy
        policy_path = "app/lib/password_policy.rb"
        return if destination_file?(policy_path)

        template "password_policy.rb.tt", policy_path
      end

      private

      def add_pin(path, line)
        content = read_destination(path)
        append_to_file(path, "#{line}\n") unless content.include?(line)
      end

      def destination_file?(path)
        File.exist?(File.join(destination_root, path))
      end

      def read_destination(path)
        File.read(File.join(destination_root, path))
      end
    end
  end
end
