// Example: Load Rails libraries in Vite.
//
import * as Turbo from '@hotwired/turbo'

import Turn from '@domchristie/turn'

// import ActiveStorage from "@rails/activestorage";
// ActiveStorage.start();
//
// // Import all channels.
// const channels = import.meta.globEager('./**/*_channel.js')

// Example: Import a stylesheet in app/frontend/index.css
import '../../assets/stylesheets/application.tailwind.css'
window.Turbo = Turbo

// Page transitions
Turn.config.experimental.viewTransitions = true
Turn.start()

document.addEventListener('turbo:before-frame-render', (event) => {
  if (document.startViewTransition) {
    event.preventDefault()

    document.startViewTransition(() => {
      event.detail.resume()
    })
  }
})
