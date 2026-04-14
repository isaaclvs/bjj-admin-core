import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas", "input"]

  connect() {
    this.ctx     = this.canvasTarget.getContext("2d")
    this.drawing = false
    this.ctx.strokeStyle = "#000"
    this.ctx.lineWidth   = 2
    this.ctx.lineCap     = "round"
  }

  startDrawing(event) {
    this.drawing = true
    this.ctx.beginPath()
    this.ctx.moveTo(...this.#coords(event))
  }

  draw(event) {
    if (!this.drawing) return
    event.preventDefault()
    this.ctx.lineTo(...this.#coords(event))
    this.ctx.stroke()
  }

  stopDrawing() {
    this.drawing = false
    this.inputTarget.value = this.canvasTarget.toDataURL()
  }

  clear() {
    this.ctx.clearRect(0, 0, this.canvasTarget.width, this.canvasTarget.height)
    this.inputTarget.value = ""
  }

  #coords(event) {
    const rect   = this.canvasTarget.getBoundingClientRect()
    const src    = event.touches?.[0] ?? event
    const scaleX = this.canvasTarget.width / rect.width
    const scaleY = this.canvasTarget.height / rect.height
    return [
      (src.clientX - rect.left) * scaleX,
      (src.clientY - rect.top) * scaleY
    ]
  }
}
