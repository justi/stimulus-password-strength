# Changelog

## 0.1.9

- removed positional Tailwind utilities from the default `toggle_class` so the show/hide icon no longer gets a second vertical translation on host apps that also use the inline `toggle_style`
- removed default layout utility classes from the label row, status row, requirements row, and strength bar wrappers so layout mechanics now live in `*_style` only
- documented that `toggle_class` should stay visual only and must not reintroduce `absolute`, `right-*`, `top-1/2`, or `-translate-y-1/2`
- documented that other row and bar `*_class` settings should also stay visual-only
- refreshed the installer template to reflect the new toggle customization contract

## 0.1.8

- moved the field wrapper and label row layout into inline style defaults so critical flex/position behavior no longer depends on host-app utility classes
- strengthened the toggle inline style with button-reset mechanics and a stable hit area contract
- changed the default strength-label style to a fixed width to prevent layout shift across locales
- added dummy-app hostile-style coverage plus isolated render assertions for the new layout contracts

## 0.1.7

- moved password toggle positioning into inline style defaults so the show/hide icon stays inside the input even when host-app Tailwind utilities are incomplete
- removed the `linked_flow` adaptation section from the public README

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
