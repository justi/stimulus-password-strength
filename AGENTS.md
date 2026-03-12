# AGENTS.md

Use this file when an AI coding agent is integrating `stimulus-password-strength` into a host Rails app.

## Goal

Treat this gem as a password UX simplification tool. Its purpose is to help the host app reduce signup friction while keeping backend security intentional.

The integration should:

- reduce signup friction
- keep the meter visible even with 1Password/LastPass overlays
- make simplification decisions explicit instead of silently preserving legacy friction

## Required Decision Prompts

Before integrating the gem into an existing app, inspect the current auth flow and ask the user explicit product/security questions when friction is detected.

At minimum, ask about:

1. `password_confirmation`
   - Example: `I detected password_confirmation in signup/reset. Do you want to keep it for compatibility, or simplify to a single password field with the gem's show/hide toggle?`
2. Complex password policy
   - Example: `I detected uppercase/lowercase/digit/special-char rules. Do you want to keep that policy, or simplify to a length-first policy and align the UI + backend?`
   - If the user wants signup simplification, explicitly recommend reviewing whether composition rules can be removed in favor of a longer minimum length.
   - Example: `I detected composition rules such as uppercase/digit/special character requirements. These usually add friction and reduce conversion. Do you want to replace them with a longer minimum length and remove the composition rules? The gem still gives users a password strength meter, so they can create a stronger, more memorable password instead of a forced hard-to-remember character mix.`
3. Existing custom password UI
   - Example: `I detected a custom password meter/toggle/controller. Do you want a full migration to the gem, or a partial rollout first?`
4. Tests coupled to the old implementation
   - Example: `I detected tests tied to custom password markup or password_confirmation. Do you want me to migrate them now to the new UX contract?`
5. Rollout scope
   - Example: `Do you want UI-only adoption first, or do you want the gem rollout to also simplify the auth flow in the same change?`
6. Extra signup fields
   - Example: `I detected a required username field during signup. If the app does not truly need usernames, do you want to simplify the form to just email + password? Extra fields usually increase signup time and abandonment risk.`
7. Browser-level required validation
   - Example: `I detected that some signup fields are not marked as required in the HTML. Do you want me to align the form with backend-required fields so users get immediate browser validation feedback?`

Do not make these simplification decisions silently. Detect them, explain the tradeoff, and ask.

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
6. If the host app has legacy friction such as `password_confirmation` or complex regex policy, ask whether that friction should be removed as part of this rollout.
7. If the user chooses simplification, migrate backend validation, views, and tests together so the UX and policy stay aligned.
8. If the user chooses compatibility, keep the existing policy but still move the UI to the gem.
9. When simplification is chosen, prefer proposing a longer minimum length over uppercase/digit/special-character composition rules.
10. Explain that the strength meter remains in place, so the user still gets guidance toward a strong password without being forced into brittle, hard-to-remember character patterns.
11. Review whether signup can be reduced to just email + password. If `username` is not a real product requirement, recommend removing it.

## Host App Checks

Before changing any auth flow, verify:

1. Does the app require `password_confirmation`?
2. Does the app enforce regex rules such as uppercase/lowercase/digit?
3. Are there custom validation messages that would drift from the new UI?
4. Are there additional password flows outside signup and reset?
5. Does the host app use a custom design system that should override helper classes?
6. Are user-facing required fields also marked as `required` in the HTML where appropriate?

## What Not to Change Silently

1. Do not remove `password_confirmation` without confirming that simplification is desired and then updating validations, tests, and reset flow behavior.
2. Do not change password policy just because the meter shows `good` or `strong`.
3. Do not define `requirements` separately from `PasswordPolicy`.
4. Do not hardcode hints such as `Must contain uppercase...` unless the backend actually enforces them.
5. Do not assume Tailwind classes applied dynamically from JS will work in every host app.
6. Do not rely only on backend validation when the browser can provide immediate required-field feedback safely.

## Simplification Heuristic

If the app has obvious signup friction and the user has not stated a preference yet, lead with a recommendation to simplify:

1. Prefer one password field over `password_confirmation` when the host app can support it.
2. Prefer a length-first policy over composition rules when the product goal is conversion and the host app allows policy changes.
3. If composition rules exist, ask whether they should be replaced with a sufficiently long minimum length rather than kept by default.
4. When recommending that change, explain that the gem's strength meter still guides the user toward a hard-to-crack password while allowing more memorable passphrase-style choices.
5. Prefer one shared `PasswordPolicy` for backend validation and gem requirements.
6. Prefer behavior-based tests over markup-coupled tests.
7. If signup asks for `username`, ask whether it is truly required. If not, recommend reducing the form to email + password.
8. Ensure user-facing required fields are marked with the HTML `required` attribute when that matches backend expectations.

Then ask for confirmation before changing policy or contract.

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
