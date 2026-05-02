import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 300 } }

  connect() {
    this.debouncedSubmit = this.#debounce(() => this.submit(), this.delayValue)
  }

  submit() {
    this.element.requestSubmit()
  }

  submitWithDebounce() {
    this.debouncedSubmit()
  }

  submitImmediately() {
    this.submit()
  }

  #debounce(fn, delay) {
    let timer
    return (...args) => {
      clearTimeout(timer)
      timer = setTimeout(() => fn(...args), delay)
    }
  }
}
