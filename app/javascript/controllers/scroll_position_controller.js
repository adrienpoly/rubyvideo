import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="scroll-position"
export default class extends Controller {
  static targets = ['active']

  connect () {
    this.centerCurrentTalk()
  }

  centerCurrentTalk () {
    if (!this.hasActiveTarget) return

    const activeCard = this.activeTarget

    const container = this.element
    const containerHeight = container.clientHeight
    const cardPosition = activeCard.offsetTop
    const cardHeight = activeCard.clientHeight

    // Calculate scroll position to center the card
    const scrollPosition = cardPosition - (containerHeight / 2) + (cardHeight / 2)
    container.scrollTop = Math.max(0, scrollPosition)
  }
}
