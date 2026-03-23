import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["selected", "empty"]

  addArticle(event) {
    const item = event.currentTarget.closest("[data-leaf-id]")
    if (!item) return

    const leafId = item.dataset.leafId
    const title = item.querySelector(".flex-item-grow").textContent.trim()

    // Don't add duplicates
    if (this.selectedTarget.querySelector(`input[value="${leafId}"]`)) return

    const entry = document.createElement("div")
    entry.className = "pad-half fill-selected border-radius flex align-center gap"
    entry.innerHTML = `
      <span class="flex-item-grow">${this.escapeHtml(title)}</span>
      <input type="hidden" name="article_ids[]" value="${leafId}">
      <button type="button" class="btn btn--small" data-action="click->issue-composer#removeArticle">✕</button>
    `

    this.selectedTarget.appendChild(entry)
    if (this.hasEmptyTarget) this.emptyTarget.hidden = true
  }

  removeArticle(event) {
    event.currentTarget.closest(".flex").remove()
    if (this.selectedTarget.children.length === 0 && this.hasEmptyTarget) {
      this.emptyTarget.hidden = false
    }
  }

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  }
}
