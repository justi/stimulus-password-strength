# stimulus-password-strength

Importmap-friendly password strength field for Rails 8+ with Stimulus, `zxcvbn`, and Tailwind-friendly markup.

## Product Goal

Reduce signup abandonment by improving password UX:

- one password field with `show/hide`
- real-time strength meter
- requirements placed above the input so they stay visible with 1Password/LastPass overlays
- no Node.js required in the host app
- simpler signup flow while keeping security standards and sound UX practices

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
  config.text_style = "min-width: 2.5rem; text-align: right; white-space: nowrap;"
  config.status_row_class = "flex min-h-5 items-center gap-2"
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

## Post-Install Checklist

1. Signup: weak password -> backend validation still works.
2. Signup: `requirements` match `PasswordPolicy` and model validation.
3. Signup: `Show/Hide` toggle works on mobile and desktop.
4. Password reset: meter, requirements, and toggle behave the same way as signup.
5. Password autofill: the strength meter and requirements refresh correctly.
6. JS or `zxcvbn` failure: the form still allows submission.
7. i18n: `show/hide/weak/fair/good/strong` labels are correct for the current locale.

## Best Practices for the Installing Agent

Treat this gem as a UI layer, not as password security policy.

### Installation Goal

Improve password UX and reduce signup friction:

- the meter must remain visible even with password manager overlays
- the toggle must be obvious and accessible
- the host app should keep its own backend validation until it is intentionally migrated

### Rollout Procedure

1. Add the gem to `Gemfile` and run:

```bash
bundle install
bin/rails generate stimulus_password_strength:install
```

2. Use the generated `PasswordPolicy` as the shared source of truth for backend rules and UI rules.
3. Replace the main password field with `password_strength_field`, passing `requirements: PasswordPolicy.requirements`.
4. Update every user-facing password view. Minimum:
   - signup / registration
   - password reset / change password
5. If the app has additional password-setting flows, update them too:
   - invitation acceptance
   - onboarding set password
   - admin-created account activation
   - forced password change
6. Do not remove `password_confirmation` if the host app still requires it.
7. Do not change backend password validation during the first rollout unless it is already wired to `PasswordPolicy`.
8. Roll out the UI first, then decide separately whether to simplify the backend policy.

### What the Agent Must Verify in the Host App

1. Review the user model and auth controllers:
   - does the app require `password_confirmation`
   - does the app require regex rules such as uppercase/lowercase/digit
   - are there custom validation messages
2. Move at least one backend rule into `PasswordPolicy` before exposing `requirements` in the UI.
3. Remove or update copy that promises rules different from what the backend actually enforces.
4. If you use a custom header row above the input, keep a stable status width or right alignment so the layout does not jump.
5. If the host app has its own design system, pass custom classes into the helper instead of forking the gem.

### What the Agent Should Not Change Automatically

1. Do not remove `password_confirmation` without reviewing validations, tests, and the reset flow.
2. Do not change the password policy just because the meter says `good` or `strong`.
3. Do not define `requirements` separately from `PasswordPolicy`, or the UI will drift from backend validation.
4. Do not hardcode hints such as `Must contain uppercase...` unless the backend actually enforces that rule.
5. Do not assume dynamically applied Tailwind classes from JS will work in every host app.

### Minimal Smoke Test After Installation

1. Signup: enter a weak password and check the meter, toggle, and backend error.
2. Signup with 1Password/LastPass enabled: confirm the meter is still visible.
3. Password reset: verify the same component in the second flow.
4. Browser autofill: confirm the meter updates after typing or autofill.
5. Mobile viewport: the toggle must not overlap the text or password manager icons.

### When to Change Password Policy

Change backend policy only as a separate product decision. This gem does not replace:

- model validation
- rate limiting
- anti-abuse controls
- password reset security

## Example Adaptation: `linked_flow`

The gem was also used in `../linked_flow` as an example of a more opinionated UX simplification:

- signup and password reset work without `password_confirmation`
- the UI uses `password_strength_field`
- backend validation and UI both use a shared `PasswordPolicy` with minimum password length

Recommended rollout order:

1. Add the gem as UI-only.
2. Switch signup and reset views to `password_strength_field`.
3. Only then decide whether to simplify backend policy and business tests.

## Nice Follow-Ups After `0.1.0`

1. Generator for JS test scaffolding in the host app.
2. Wider CI coverage for Rails `8.0` and `8.1`.
3. `confirmation: true/false` helper option.
4. Public analytics event documentation for signup funnel instrumentation.
5. More examples for integrating with host app design systems.

## Development

```bash
cd /Users/justi/projects_prod/stimulus-password-strength
bundle install
npm install
bundle exec rake test
npm test
```

## Release Hygiene

- full publication checklist: [PUBLISH_CHECKLIST.md](PUBLISH_CHECKLIST.md)
- change history: [CHANGELOG.md](CHANGELOG.md)
