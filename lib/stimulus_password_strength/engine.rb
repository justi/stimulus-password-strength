# frozen_string_literal: true

module StimulusPasswordStrength
  class Engine < ::Rails::Engine
    initializer "stimulus_password_strength.assets" do |app|
      next unless app.config.respond_to?(:assets)

      app.config.assets.paths << root.join("app/javascript")
      app.config.assets.paths << root.join("vendor/javascript")
    end

    initializer "stimulus_password_strength.importmap", before: "importmap" do |app|
      next unless app.config.respond_to?(:importmap)

      app.config.importmap.paths << root.join("config/importmap.rb")
    end

    initializer "stimulus_password_strength.helpers" do
      ActiveSupport.on_load(:action_view) do
        include StimulusPasswordStrength::Helper
      end
    end
  end
end
