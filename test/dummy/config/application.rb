# frozen_string_literal: true

require "rails"
require "action_controller/railtie"
require "action_view/railtie"
require "active_model/railtie"

require "stimulus_password_strength"

module Dummy
  class Application < Rails::Application
    config.root = File.expand_path("..", __dir__)
    config.eager_load = false
    config.hosts << "www.example.com"
    config.secret_key_base = "test-secret-key-base"
    config.consider_all_requests_local = true
    config.logger = Logger.new($stdout)
    config.log_level = :fatal
    config.autoload_paths << root.join("lib")
  end
end
