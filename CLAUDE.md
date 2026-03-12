# CLAUDE.md

For integration guidance, treat [AGENTS.md](AGENTS.md) as the canonical source.

## Claude-Specific Notes

1. Detect auth friction before changing code: `password_confirmation`, regex-heavy policy, custom password UI, and tests coupled to old markup.
2. Ask explicit decision questions before assuming compatibility mode. This gem is meant to simplify auth UX, not only replace markup.
3. If the app has uppercase/digit/special-character rules and the user wants simplification, ask whether they should be replaced with a longer minimum length to reduce signup friction.
4. When making that recommendation, explain that the gem still provides a strength meter, so users are guided toward stronger and more memorable passwords instead of forced character patterns.
5. If signup includes `username`, ask whether it is truly needed. If not, recommend reducing the form to email + password.
6. Check whether user-facing required fields are also marked with the HTML `required` attribute so the browser can assist with validation immediately.
7. If the user wants simplification, migrate policy, views, and tests together instead of doing UI-only halfway changes.
8. Prefer using the generated `PasswordPolicy` as the source of truth for both model validation and gem requirements.
9. Update every user-facing password flow, not just signup.
10. After integration, run a smoke test for signup, password reset, autofill, and password manager overlay behavior.
