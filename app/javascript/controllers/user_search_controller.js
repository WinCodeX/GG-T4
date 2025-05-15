import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.handleClickOutside = this._handleClickOutside.bind(this)
    document.addEventListener("click", this.handleClickOutside)
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside)
  }

  search() {
    const query = this.inputTarget.value.trim()
    const resultsBox = document.getElementById("search-results")

    if (query.length < 1) {
      resultsBox.classList.add("hidden")
      resultsBox.innerHTML = ""
      return
    }

    fetch(`/search_users?query=${encodeURIComponent(query)}`)
      .then((response) => response.text())
      .then((html) => {
        resultsBox.innerHTML = html
        resultsBox.classList.remove("hidden")
      })
      .catch((err) => console.error("Search failed", err))
  }

  clear() {
    this.inputTarget.value = "" // Clear the input
    const resultsBox = document.getElementById("search-results")
    resultsBox.classList.add("hidden") // Hide results
    resultsBox.innerHTML = "" // Optionally clear HTML
  }

  _handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      const resultsBox = document.getElementById("search-results")
      resultsBox.classList.add("hidden")
    }
  }
}