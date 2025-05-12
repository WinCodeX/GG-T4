import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  search() {
    const query = this.inputTarget.value.trim()
    if (query.length < 1) return

    fetch(`/search_users?query=${encodeURIComponent(query)}`)
      .then((response) => response.text())
      .then((html) => {
        const box = document.getElementById("search-results")
        if (box) box.innerHTML = html
      })
      .catch((err) => console.error("Search failed", err))
  }
}
