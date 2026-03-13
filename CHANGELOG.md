# Changelog

## 0.1.6

- darkened the default password strength track so the bar rail stays visible against light host-app backgrounds

## 0.1.5

- swapped the default order of the password strength label and bar so the label stays right-aligned in the status rail
- updated the default status-row layout to use the new order without requiring host-app overrides
- expanded rendering tests to cover the new default status-row class and style contract

## 0.1.4

- fixed a rendering bug where the password strength bar could stay visually hidden even though the label updated
- moved critical strength-bar and requirement layout fallbacks into inline styles so host-app Tailwind overrides cannot collapse the bar height or visibility
- preserved requirement base typography when pending/met/unmet states are updated in Stimulus
- expanded test coverage for the new style fallback properties and visible-bar behavior

## 0.1.3

- clarified the public README around adaptive usage modes: UI-only integration vs conversion-focused signup simplification
- expanded `AGENTS.md` and `CLAUDE.md` so coding agents screen the host app before integration and ask explicit questions about password confirmation, composition rules, extra signup fields, and HTML `required` support
- documented the recommended simplification path: length-first password policy, one password field with show/hide, and email + password only when extra signup fields are not true product requirements

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
