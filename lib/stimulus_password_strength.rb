# frozen_string_literal: true

require_relative "stimulus_password_strength/version"
require_relative "stimulus_password_strength/configuration"
require_relative "stimulus_password_strength/helper"
require_relative "stimulus_password_strength/engine" if defined?(Rails)

module StimulusPasswordStrength
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
