# frozen_string_literal: true

require_relative "lib/stimulus_password_strength/version"

Gem::Specification.new do |spec|
  spec.name = "stimulus-password-strength"
  spec.version = StimulusPasswordStrength::VERSION
  spec.authors = ["Justyna Wojtczak"]
  spec.email = ["justine84@gmail.com"]

  spec.summary = "Password strength field for Rails 8+ with Stimulus, zxcvbn and Tailwind."
  spec.description = "Importmap-friendly Rails engine with helper, partial and installer for password strength UX."
  spec.homepage = "https://github.com/justi/stimulus-password-strength"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "#{spec.homepage}/tree/main"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |file|
      (file == gemspec) ||
        file.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile package-lock.json package.json node_modules/])
    end
  end

  spec.require_paths = ["lib"]
  spec.add_dependency "rails", ">= 8.0", "< 9.0"
end
