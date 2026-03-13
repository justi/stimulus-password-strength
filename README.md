# stimulus-password-strength

Importmap-friendly password strength field for Rails 8+ with Stimulus, `zxcvbn`, and Tailwind-friendly markup.

Use it either as a drop-in password UX upgrade or as part of a broader signup simplification rollout. The same gem can support a conservative integration that only adds the strength meter and toggle, or a conversion-focused integration that helps remove unnecessary auth friction such as password confirmation, composition rules, or extra signup fields.

## Product Goal

Reduce signup abandonment by improving password UX:

- one password field with `show/hide`
- real-time strength meter
- requirements placed above the input so they stay visible with 1Password/LastPass overlays
- no Node.js required in the host app
- simpler signup flow while keeping security standards and sound UX practices

This gem is intentionally adaptive. Depending on the host app and the user's product goal, it can be used in two valid modes:

- UI integration only: add the password strength meter, requirements, and show/hide toggle while keeping the existing auth policy
- conversion-focused simplification: use the gem rollout to simplify the signup flow, reduce unnecessary password friction, and improve registration completion

## What the Gem Includes

- Rails engine: `StimulusPasswordStrength::Engine`
- Stimulus controller: `password-strength`
- vendored `zxcvbn.js`
- helper: `password_strength_field`
- partial: `_field.html.erb`
- installer: `rails g stimulus_password_strength:install`
- default i18n files: `en`, `pl`

## Installation

Add the gem to your app:

```ruby
gem "stimulus-password-strength"
```

Then run:

```bash
bundle install
bin/rails generate stimulus_password_strength:install
```

The installer:

- adds importmap pins to `config/importmap.rb`
- registers the controller in `app/javascript/controllers/index.js`
- creates `config/initializers/stimulus_password_strength.rb`
- creates `app/lib/password_policy.rb` as the single source of truth for the rules shown in the UI

## Usage

```erb
<%= form_with(model: @user) do |form| %>
  <%= password_strength_field form, :password,
      placeholder: "Minimum 12 characters",
      requirements: PasswordPolicy.requirements %>
<% end %>
```

With custom labels:

```erb
<%= password_strength_field form, :password,
    strength_labels: { weak: "Weak", fair: "Fair", good: "Good", strong: "Strong" },
    toggle_labels: { show: "Show", hide: "Hide" } %>
```

## Password Policy

The installer creates a sample [password_policy.rb.tt](/Users/justi/projects_prod/stimulus-password-strength/lib/generators/stimulus_password_strength/install/templates/password_policy.rb.tt) file that should become the shared source of truth for:

- backend model validation
- requirements rendered by the gem

Example host app validation:

```ruby
# app/models/user.rb
validates :password, length: { minimum: PasswordPolicy::MIN_LENGTH }, allow_nil: true
```

Example view usage:

```erb
<%= password_strength_field form, :password,
    requirements: PasswordPolicy.requirements %>
```

`min_length` can use dynamic live copy from `PasswordPolicy`, for example:

```ruby
REQUIREMENTS = [
  {
    rule: :min_length,
    value: MIN_LENGTH,
    label: "At least #{MIN_LENGTH} characters",
    remaining_singular: "Type 1 more character",
    remaining_plural: "Type %{count} more characters",
    met_label: "#{MIN_LENGTH}+ chars"
  }
].freeze
```

The gem does not try to infer rules from the model and does not add hidden fallbacks for `requirements`. The host app must pass policy explicitly from `PasswordPolicy`.

## Configuration

`config/initializers/stimulus_password_strength.rb`:

```ruby
StimulusPasswordStrength.configure do |config|
  config.input_class = "w-full rounded-md border px-3 py-2 pr-16"
  config.wrapper_style = "position: relative;"
  config.toggle_style = "position: absolute; right: 0.75rem; top: 50%; transform: translateY(-50%);"
  config.text_style = "width: 5.5rem; text-align: right; white-space: nowrap;"
  config.status_row_class = "flex min-h-5 flex-row-reverse items-center justify-start gap-2"
  config.requirements_style = "min-height: 1rem;"
  config.requirement_pending_style = "color: #6b7280;"
  config.requirement_met_style = "color: #047857;"
  config.requirement_unmet_style = "color: #b91c1c;"

  config.bar_colors = {
    weak: "#f87171",
    fair: "#fbbf24",
    good: "#22c55e",
    strong: "#059669"
  }
end
```

Adding more languages is standard Rails I18n: add another locale file in [config/locales](/Users/justi/projects_prod/stimulus-password-strength/config/locales).

## Layout Contract

The gem now treats critical layout as component mechanics, not host-app theme:

- the password-field wrapper must stay positioned
- the show/hide toggle must stay inside the input
- the label/requirements row must remain a flex row
- the strength label uses a fixed width by default

If you override these settings, preserve the same mechanics and keep right-side padding on the input (`pr-16` or equivalent) so typed text does not collide with the toggle.

## Post-Install Checklist

1. Signup: weak password -> backend validation still works.
2. Signup: `requirements` match `PasswordPolicy` and model validation.
3. Signup: `Show/Hide` toggle works on mobile and desktop.
4. Password reset: meter, requirements, and toggle behave the same way as signup.
5. Password autofill: the strength meter and requirements refresh correctly.
6. JS or `zxcvbn` failure: the form still allows submission.
7. i18n: `show/hide/weak/fair/good/strong` labels are correct for the current locale.

## Migrating from Custom Password UI

If the host app already has its own password strength UI, this is a migration, not a fresh install.

Typical signs:

- a custom Stimulus controller such as `password_field_controller.js`
- manual strength bar markup in signup or reset views
- a custom `zxcvbn` pin in `config/importmap.rb`
- tests tied to old DOM details such as `data-testid="password-input"`

Recommended migration order:

1. Add the gem and run the installer.
2. Move the real password rule into `PasswordPolicy`.
3. Replace the custom password markup with `password_strength_field` in:
   - signup / registration
   - password reset / change password
4. Remove the old password-specific Stimulus controller and its registration from `app/javascript/controllers/index.js`.
5. Remove duplicate importmap pins if the app already pinned `zxcvbn` or a custom password controller setup.
6. Update tests to target user-facing behavior, not the old internal DOM structure.

For example, prefer:

```ruby
fill_in "Password", with: "SecurePass123!"
```

instead of a selector tied to the old implementation:

```ruby
find("[data-testid='password-input']").fill_in with: "SecurePass123!"
```

After migration, there should be only one password UI implementation in the app: the gem-based one.

## Agent Guidance

If you are installing this gem through an AI coding agent, use:

- [AGENTS.md](AGENTS.md) for general agent instructions
- [CLAUDE.md](CLAUDE.md) for Claude-specific workflow notes

These files contain agent-specific project screening, rollout, and simplification guidance. They tell the agent how to inspect the host app, which questions to ask before changing auth UX, and how to choose between compatibility mode and conversion-focused simplification. Keep that logic there, not in this README.

## Development

```bash
cd /Users/justi/projects_prod/stimulus-password-strength
bundle install
npm install
bundle exec rake test
npm test
```
