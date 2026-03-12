import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "toggle", "statusRow", "strengthTrack", "strengthBar", "strengthText", "requirement", "showIcon", "hideIcon"]

  connect() {
    this.syncToggleState()
    this.evaluate()
    this.loadZxcvbn()
  }

  async loadZxcvbn() {
    try {
      const mod = await import("zxcvbn")
      this.zxcvbn = mod.default || mod
      this.evaluate()
    } catch (error) {
      this.zxcvbn = null
    }
  }

  toggle() {
    const isPassword = this.inputTarget.type === "password"
    this.inputTarget.type = isPassword ? "text" : "password"
    this.syncToggleState()
  }

  evaluate() {
    const password = this.inputTarget.value

    if (password.length === 0) {
      this.statusRowTarget.style.visibility = "hidden"
      this.strengthTrackTarget.style.visibility = "hidden"
      this.strengthBarTarget.style.width = "0%"
      this.strengthBarTarget.style.backgroundColor = ""
      this.strengthTextTarget.textContent = ""
      this.strengthTextTarget.style.color = ""
      this.updateRequirements(password)
      return
    }

    this.statusRowTarget.style.visibility = "visible"
    this.strengthTrackTarget.style.visibility = "visible"
    const score = this.scoreFor(password)
    const widths = [10, 25, 50, 75, 100]
    const labels = ["weak", "weak", "fair", "good", "strong"]

    this.strengthBarTarget.style.width = `${widths[score]}%`
    this.strengthBarTarget.className = this.barClasses()
    this.strengthBarTarget.style.backgroundColor = this.barColor(score)
    this.strengthTextTarget.textContent = this.label(labels[score])
    this.strengthTextTarget.className = this.textClasses()
    this.strengthTextTarget.style.color = this.textColor(score)
    this.updateRequirements(password)
  }

  scoreFor(password) {
    if (this.zxcvbn) {
      return this.zxcvbn(password).score
    }

    // Fallback when zxcvbn cannot be loaded (offline/asset issue).
    let score = 0
    if (password.length >= 8) score += 1
    if (password.length >= 12) score += 1
    if (/[A-Z]/.test(password) && /[a-z]/.test(password)) score += 1
    if (/\d/.test(password) || /[^A-Za-z0-9]/.test(password)) score += 1
    return Math.min(score, 4)
  }

  label(key) {
    const map = {
      weak: this.element.dataset.passwordStrengthWeakLabel,
      fair: this.element.dataset.passwordStrengthFairLabel,
      good: this.element.dataset.passwordStrengthGoodLabel,
      strong: this.element.dataset.passwordStrengthStrongLabel
    }

    return map[key] || key
  }

  barClasses() {
    return this.element.dataset.passwordStrengthBarBaseClass || "h-full rounded-full transition-all duration-300"
  }

  textClasses() {
    return this.element.dataset.passwordStrengthTextBaseClass || "text-xs"
  }

  barColor(score) {
    const colors = [
      this.element.dataset.passwordStrengthWeakBarColor || "#f87171",
      this.element.dataset.passwordStrengthWeakBarColor || "#f87171",
      this.element.dataset.passwordStrengthFairBarColor || "#fbbf24",
      this.element.dataset.passwordStrengthGoodBarColor || "#22c55e",
      this.element.dataset.passwordStrengthStrongBarColor || "#059669"
    ]

    return colors[score]
  }

  textColor(score) {
    const colors = [
      this.element.dataset.passwordStrengthWeakTextColor || "#ef4444",
      this.element.dataset.passwordStrengthWeakTextColor || "#ef4444",
      this.element.dataset.passwordStrengthFairTextColor || "#d97706",
      this.element.dataset.passwordStrengthGoodTextColor || "#16a34a",
      this.element.dataset.passwordStrengthStrongTextColor || "#047857"
    ]

    return colors[score]
  }

  syncToggleState() {
    const isPassword = this.inputTarget.type === "password"
    const label = isPassword
      ? this.toggleTarget.dataset.showLabel
      : this.toggleTarget.dataset.hideLabel

    this.toggleTarget.setAttribute("aria-label", label)
    this.toggleTarget.setAttribute("title", label)

    if (this.hasShowIconTarget) this.showIconTarget.hidden = !isPassword
    if (this.hasHideIconTarget) this.hideIconTarget.hidden = isPassword
  }

  updateRequirements(password) {
    this.requirementTargets.forEach((element) => {
      const isMet = this.requirementMet(element, password)

      if (password.length === 0) {
        element.setAttribute("aria-hidden", "false")
        element.innerHTML = this.escapeHtml(element.dataset.label)
        element.style.cssText = `${element.dataset.pendingStyle}; visibility: visible;`
        return
      }

      element.setAttribute("aria-hidden", "false")
      element.innerHTML = isMet
        ? this.metRequirementMarkup(element)
        : this.escapeHtml(this.requirementLabel(element, password))
      element.style.cssText = isMet
        ? `${element.dataset.metStyle}; visibility: visible;`
        : `${element.dataset.unmetStyle}; visibility: visible;`
    })
  }

  requirementMet(element, password) {
    switch (element.dataset.rule) {
      case "min_length":
        return password.length >= Number(element.dataset.value)
      case "uppercase":
        return /[A-Z]/.test(password)
      default:
        return false
    }
  }

  requirementLabel(element, password) {
    switch (element.dataset.rule) {
      case "min_length": {
        const required = Number(element.dataset.value)
        const remaining = Math.max(required - password.length, 0)

        if (remaining === 1 && element.dataset.remainingSingular) {
          return element.dataset.remainingSingular
        }

        if (remaining > 1 && element.dataset.remainingPlural) {
          return element.dataset.remainingPlural.replace("%{count}", remaining)
        }

        return element.dataset.label
      }
      default:
        return element.dataset.label
    }
  }

  metRequirementMarkup(element) {
    const label = this.escapeHtml(element.dataset.metLabel || element.dataset.label)
    return `<span style="display: inline-flex; align-items: center; gap: 0.25rem;"><span aria-hidden="true">✓</span><span>${label}</span></span>`
  }

  escapeHtml(value) {
    return String(value)
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#39;")
  }
}
