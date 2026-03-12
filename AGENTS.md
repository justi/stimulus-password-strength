# AGENTS.md

Use this file when an AI coding agent is integrating `stimulus-password-strength` into a host Rails app.

## Goal

Treat this gem as a UI layer for password UX, not as password security policy.

The integration should:

- reduce signup friction
- keep the meter visible even with 1Password/LastPass overlays
- preserve backend validation until the host app intentionally migrates it

## Recommended Rollout

1. Add the gem and run:

```bash
bundle install
bin/rails generate stimulus_password_strength:install
```

2. Use the generated `PasswordPolicy` as the shared source of truth for backend rules and UI requirements.
3. Replace the main password field with `password_strength_field`, passing `requirements: PasswordPolicy.requirements`.
4. Update all user-facing password views. Minimum:
   - signup / registration
   - password reset / change password
5. If the app has additional password-setting flows, update them too:
   - invitation acceptance
   - onboarding set password
   - admin-created account activation
   - forced password change
6. Do not remove `password_confirmation` if the host app still requires it.
7. Do not change backend validation during the first rollout unless validation is already wired to `PasswordPolicy`.
8. Roll out the UI first, then decide separately whether to simplify backend policy.

## Host App Checks

Before changing any auth flow, verify:

1. Does the app require `password_confirmation`?
2. Does the app enforce regex rules such as uppercase/lowercase/digit?
3. Are there custom validation messages that would drift from the new UI?
4. Are there additional password flows outside signup and reset?
5. Does the host app use a custom design system that should override helper classes?

## What Not to Change Automatically

1. Do not remove `password_confirmation` without reviewing validations, tests, and reset flow behavior.
2. Do not change password policy just because the meter shows `good` or `strong`.
3. Do not define `requirements` separately from `PasswordPolicy`.
4. Do not hardcode hints such as `Must contain uppercase...` unless the backend actually enforces them.
5. Do not assume Tailwind classes applied dynamically from JS will work in every host app.

## Minimal Smoke Test

1. Signup: weak password -> meter, toggle, and backend validation all behave correctly.
2. Signup with 1Password/LastPass enabled: meter and requirements remain visible.
3. Password reset: the same component behaves consistently in the second flow.
4. Browser autofill: meter and requirements refresh after typing or autofill.
5. Mobile viewport: toggle does not overlap text or password manager icons.

## Policy Reminder

This gem does not replace:

- model validation
- rate limiting
- anti-abuse controls
- password reset security
