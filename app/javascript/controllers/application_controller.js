import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "query", "loadingResults"];

  connect() {
    if ("geolocation" in navigator && !this.queryTarget.value) {
      const placeholder = this.queryTarget.placeholder;
      this.queryTarget.placeholder = "loading your location...";

      navigator.geolocation.getCurrentPosition(
        ({ coords }) => {
          const { latitude, longitude } = coords;
          this.queryTarget.value = `${latitude},${longitude}`;
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
    this.formTarget.submit();
  }
}
