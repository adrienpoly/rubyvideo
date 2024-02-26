import Turn from '@domchristie/turn'

Turn.start()

document.addEventListener('turbo:before-frame-render', (event) => {
  if (document.startViewTransition) {
    event.preventDefault()

    document.startViewTransition(() => {
      event.detail.resume()
    })
  }
})
