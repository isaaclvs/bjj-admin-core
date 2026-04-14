import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "frame"]
  static values  = { url: String, delay: { type: Number, default: 300 } }

  connect() {
    this.debouncedFilter = this.#debounce(this.filter.bind(this), this.delayValue)
  }

  filter() {
    const params = new URLSearchParams(new FormData(this.element))
    this.frameTarget.src = `${this.urlValue}?${params}`
  }

  inputTargetConnected(target) {
    target.addEventListener("input", this.debouncedFilter)
  }

  #debounce(fn, delay) {
    let timer
    return (...args) => {
      clearTimeout(timer)
      timer = setTimeout(() => fn(...args), delay)
    }
  }
}
