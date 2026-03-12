# Publish Checklist

## Goal

Ship `stimulus-password-strength` as a reusable Rails 8+ gem with verified install path, stable UI API and enough automated coverage to publish safely.

## Tasks

### 1. Repo hygiene

- [x] remove built gem artifact from version control flow
- [x] ignore `node_modules` and built `.gem` files
- [x] ensure gemspec ships README and LICENSE

**DoD**
- `git status` shows no accidental build outputs tracked
- `.gitignore` blocks local artifacts
- built gem includes docs/license files

### 2. Public release metadata

- [x] add release notes file
- [x] enable RubyGems MFA metadata
- [x] make README default to published install flow

**DoD**
- `CHANGELOG.md` exists
- gemspec includes `rubygems_mfa_required`
- README installation example does not depend on local `path:`

### 3. Helper and rendering coverage

- [x] test rendered markup from `password_strength_field`
- [x] verify i18n labels and requirement serialization
- [x] verify invalid requirement rules fail fast

**DoD**
- helper test covers main HTML contract consumed by Stimulus
- tests assert both default and localized output
- unsupported requirements raise a clear error

### 4. Installer coverage

- [x] test importmap pin insertion
- [x] test Stimulus controller registration
- [x] test initializer creation
- [x] test `PasswordPolicy` template creation
- [x] test idempotency

**DoD**
- generator test proves a fresh host app gets all required files
- rerunning installer does not duplicate pins or controller registration

### 5. Dummy app smoke test

- [x] add minimal Rails dummy app
- [x] render a form using the gem helper
- [x] assert response contains the expected password field contract

**DoD**
- dummy app boots in test environment
- integration test hits a real route and renders the component successfully

### 6. JS behavior coverage

- [x] add lightweight Node-based tests for the Stimulus controller
- [x] test toggle behavior
- [x] test requirement label transitions
- [x] test hidden state for empty password

**DoD**
- JS tests run without bundling the host app
- core controller UX behavior is covered by automation

### 7. Verification

- [x] run Ruby test suite
- [x] run JS test suite

**DoD**
- both suites pass locally
- release candidate is blocked only by product decisions, not missing test scaffolding
