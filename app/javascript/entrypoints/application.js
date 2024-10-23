// Example: Load Rails libraries in Vite.
//
import '@hotwired/turbo-rails'

import Turn from '@domchristie/turn'

// import ActiveStorage from "@rails/activestorage";
// ActiveStorage.start();
//
// // Import all channels.
// const channels = import.meta.globEager('./**/*_channel.js')

import '~/controllers'

// Page transitions
Turn.start()
