# Changelog

## 0.1.2

- switched gem packaging to `git ls-files`
- added a lightweight RuboCop setup for the gem repository
- simplified CI to a single `main.yml` workflow with Ruby lint, Ruby tests, and JS tests
- aligned repository tooling with the release workflow used in `price_scanner`

## 0.1.1

- first public RubyGems release
- English README for public consumers
- agent-specific installation guidance moved to `AGENTS.md` and `CLAUDE.md`
- CI reduced to the minimum useful cross-platform matrix: Ruby 3.2 on Linux and macOS
- lockfile updated for Linux and generic Ruby platforms

## 0.1.0

- first public release candidate
- Rails 8 engine with helper, partial, installer and importmap support
- Stimulus password strength controller with show/hide toggle
- vendored `zxcvbn.js` for host apps without Node
- explicit `PasswordPolicy` pattern for syncing backend rules with UI requirements
- Ruby tests for helper rendering, generator behavior and dummy app smoke flow
- lightweight JS tests for controller behavior
- public README rewritten in English
- agent-specific integration instructions moved to `AGENTS.md` and `CLAUDE.md`
