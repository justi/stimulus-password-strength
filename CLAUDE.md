# CLAUDE.md

For integration guidance, treat [AGENTS.md](AGENTS.md) as the canonical source.

## Claude-Specific Notes

1. Start with a UI-only rollout unless the host app explicitly asks to simplify backend password policy.
2. Prefer using the generated `PasswordPolicy` as the source of truth for both model validation and gem requirements.
3. Update every user-facing password flow, not just signup.
4. If the host app still requires `password_confirmation`, keep it until validations and tests are migrated deliberately.
5. After integration, run a smoke test for signup, password reset, autofill, and password manager overlay behavior.
