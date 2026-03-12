import test from "node:test"
import assert from "node:assert/strict"
import { JSDOM } from "jsdom"
import { Application } from "@hotwired/stimulus"
import PasswordStrengthController from "../../app/javascript/stimulus_password_strength_controller.js"

class DeterministicPasswordStrengthController extends PasswordStrengthController {
  async loadZxcvbn() {
    this.zxcvbn = null
  }
}

function setupDom(html, controller = DeterministicPasswordStrengthController) {
  const dom = new JSDOM(html)

  global.window = dom.window
  global.document = dom.window.document
  global.MutationObserver = dom.window.MutationObserver
  global.CustomEvent = dom.window.CustomEvent
  global.HTMLElement = dom.window.HTMLElement
  global.Element = dom.window.Element
  global.Node = dom.window.Node
  global.KeyboardEvent = dom.window.KeyboardEvent
  global.MouseEvent = dom.window.MouseEvent
  global.Event = dom.window.Event

  const application = Application.start()
  application.register("password-strength", controller)

  return {
    application,
    element: dom.window.document.querySelector("[data-controller='password-strength']"),
    input: dom.window.document.querySelector("input"),
    toggle: dom.window.document.querySelector("button"),
    cleanup() {
      application.stop()
      dom.window.close()
    }
  }
}

function fixture() {
  return `
    <div
      data-controller="password-strength"
      data-password-strength-weak-label="Weak"
      data-password-strength-fair-label="Fair"
      data-password-strength-good-label="Good"
      data-password-strength-strong-label="Strong">
      <div data-password-strength-target="statusRow" style="visibility: hidden;">
        <div data-password-strength-target="strengthTrack" style="visibility: hidden;">
          <div data-password-strength-target="strengthBar" style="width: 0%"></div>
        </div>
        <p data-password-strength-target="strengthText"></p>
      </div>
      <p
        data-password-strength-target="requirement"
        data-rule="min_length"
        data-value="12"
        data-label="At least 12 characters"
        data-remaining-singular="Type 1 more character"
        data-remaining-plural="Type %{count} more characters"
        data-met-label="12+ chars"
        data-pending-style="color: #6b7280;"
        data-met-style="color: #047857;"
        data-unmet-style="color: #b91c1c;"></p>
      <input
        type="password"
        data-password-strength-target="input"
        data-action="input->password-strength#evaluate" />
      <button
        type="button"
        data-password-strength-target="toggle"
        data-action="click->password-strength#toggle"
        data-show-label="Show"
        data-hide-label="Hide"></button>
      <svg data-password-strength-target="showIcon"></svg>
      <svg data-password-strength-target="hideIcon" hidden></svg>
    </div>
  `
}

test("keeps status row hidden for an empty password", async () => {
  const { element, cleanup } = setupDom(fixture())

  await new Promise((resolve) => setTimeout(resolve, 0))

  const statusRow = element.querySelector('[data-password-strength-target="statusRow"]')
  const requirement = element.querySelector('[data-password-strength-target="requirement"]')

  assert.equal(statusRow.style.visibility, "hidden")
  assert.equal(requirement.textContent, "At least 12 characters")

  cleanup()
})

test("toggles password visibility and accessible labels", async () => {
  const { input, toggle, cleanup } = setupDom(fixture())

  await new Promise((resolve) => setTimeout(resolve, 0))

  assert.equal(input.type, "password")
  assert.equal(toggle.getAttribute("aria-label"), "Show")

  toggle.click()
  await new Promise((resolve) => setTimeout(resolve, 0))
  assert.equal(input.type, "text")
  assert.equal(toggle.getAttribute("aria-label"), "Hide")

  toggle.click()
  await new Promise((resolve) => setTimeout(resolve, 0))
  assert.equal(input.type, "password")
  assert.equal(toggle.getAttribute("aria-label"), "Show")

  cleanup()
})

test("updates requirement copy while the password is being typed", async () => {
  const { element, input, cleanup } = setupDom(fixture())
  const requirement = element.querySelector('[data-password-strength-target="requirement"]')

  await new Promise((resolve) => setTimeout(resolve, 0))

  input.value = "abcdefghijk"
  input.dispatchEvent(new window.Event("input", { bubbles: true }))
  await new Promise((resolve) => setTimeout(resolve, 0))
  assert.equal(requirement.textContent, "Type 1 more character")

  input.value = "abcdefghijkl"
  input.dispatchEvent(new window.Event("input", { bubbles: true }))
  await new Promise((resolve) => setTimeout(resolve, 0))
  assert.match(requirement.textContent, /12\+ chars/)
  assert.match(requirement.textContent, /✓/)

  cleanup()
})
