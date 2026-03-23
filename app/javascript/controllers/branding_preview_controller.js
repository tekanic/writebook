import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["preview"]

  update() {
    // Debounce preview updates
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.refreshPreview(), 300)
  }

  refreshPreview() {
    if (!this.hasPreviewTarget) return

    const form = this.element.querySelector("form")
    if (!form) return

    const data = new FormData(form)
    const accentColor = data.get("publication_branding[accent_color]") || "#0066cc"
    const fromName = data.get("publication_branding[from_name]") || "Your Newsletter"
    const tagline = data.get("publication_branding[tagline]") || ""
    const fontFamily = data.get("publication_branding[font_family]") || "Arial"
    const footerText = data.get("publication_branding[footer_text]") || ""

    this.previewTarget.innerHTML = `
      <div class="branding-preview fill-shade border-radius pad" style="max-width: 600px; font-family: ${this.escapeHtml(fontFamily)}, sans-serif;">
        <div style="background: ${this.escapeHtml(accentColor)}; color: white; padding: 1.5rem; text-align: center; border-radius: 0.5rem 0.5rem 0 0;">
          <h2 style="margin: 0; font-size: 1.5rem;">${this.escapeHtml(fromName)}</h2>
          ${tagline ? `<p style="margin: 0.5rem 0 0; opacity: 0.9;">${this.escapeHtml(tagline)}</p>` : ""}
        </div>
        <div style="padding: 1.5rem; background: white;">
          <p style="color: #666;">Your newsletter content will appear here...</p>
        </div>
        ${footerText ? `<div style="padding: 1rem; text-align: center; color: #999; font-size: 0.85rem; border-top: 1px solid #eee;">${this.escapeHtml(footerText)}</div>` : ""}
      </div>
    `
  }

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  }
}
