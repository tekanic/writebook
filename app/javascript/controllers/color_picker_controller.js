import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hex", "contrast"]

  validate() {
    const color = this.inputTarget.value
    this.hexTarget.value = color
    this.checkContrast(color)
  }

  syncFromHex() {
    const hex = this.hexTarget.value
    if (/^#[0-9a-fA-F]{6}$/.test(hex)) {
      this.inputTarget.value = hex
      this.checkContrast(hex)
    }
  }

  checkContrast(hex) {
    if (!this.hasContrastTarget) return

    const rgb = this.hexToRgb(hex)
    if (!rgb) return

    const luminance = this.relativeLuminance(rgb)
    const whiteContrast = (1.05) / (luminance + 0.05)
    const blackContrast = (luminance + 0.05) / (0.05)

    if (whiteContrast >= 4.5) {
      this.contrastTarget.textContent = "✓ AA on white"
      this.contrastTarget.style.color = "green"
    } else {
      this.contrastTarget.textContent = "⚠ Low contrast on white"
      this.contrastTarget.style.color = "orange"
    }
  }

  hexToRgb(hex) {
    const result = /^#([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2})$/.exec(hex)
    return result ? {
      r: parseInt(result[1], 16) / 255,
      g: parseInt(result[2], 16) / 255,
      b: parseInt(result[3], 16) / 255
    } : null
  }

  relativeLuminance({ r, g, b }) {
    const sRGB = (c) => c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4)
    return 0.2126 * sRGB(r) + 0.7152 * sRGB(g) + 0.0722 * sRGB(b)
  }
}
