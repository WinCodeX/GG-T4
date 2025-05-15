import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results"];

  connect() {
    this.handleClickOutside = this._handleClickOutside.bind(this);
    document.addEventListener("click", this.handleClickOutside);
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside);
  }

  search() {
    const query = this.inputTarget.value.trim();

    if (query.length < 1) {
      this.resultsTarget.classList.add("hidden");
      this.resultsTarget.innerHTML = "";
      return;
    }

    fetch(`/search_users?query=${encodeURIComponent(query)}`)
      .then((response) => response.text())
      .then((html) => {
        this.resultsTarget.innerHTML = html;
        this.resultsTarget.classList.remove("hidden");
      })
      .catch((err) => console.error("Search failed", err));
  }

  clear() {
    this.inputTarget.value = "";
    this.resultsTarget.classList.add("hidden");
    this.resultsTarget.innerHTML = "";
  }

  _handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.resultsTarget.classList.add("hidden");
    }
  }
}