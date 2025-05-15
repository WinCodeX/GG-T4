import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["time"];

  connect() {
    this.timeTargets.forEach(el => {
      const utcTime = el.dataset.utcTime;
      if (!utcTime) return;

      const date = new Date(utcTime);
      const localTime = date.toLocaleTimeString([], {
        hour: '2-digit',
        minute: '2-digit'
      });

      el.textContent = `Last seen today at ${localTime}`;
    });
  }
}