import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "query", "results", "loadingResults"];

  connect() {
    if ("geolocation" in navigator && !this.queryTarget.value) {
      const placeholder = this.queryTarget.placeholder;
      this.queryTarget.placeholder = "detecting your location...";

      navigator.geolocation.getCurrentPosition(
        ({ coords }) => {
          const { latitude, longitude } = coords;
          const input = this.queryTarget;

          input.setAttribute("value", `${latitude},${longitude}`);
          input.selectionStart = input.selectionEnd = input.value.length;
          input.focus();

          this.getForecast();
        },
        () => {
          this.queryTarget.placeholder = placeholder;
        }
      );
    }
  }

  getForecast() {
    this.loadingResultsTarget.hidden = false;
    this.resultsTarget.hidden = true;
    this.formTarget.submit();
  }

  clearInput() {
    this.queryTarget.value = "";
  }
}
