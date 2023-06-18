// Example: Load Rails libraries in Vite.
//
import * as Turbo from "@hotwired/turbo";
Turbo.start();

import Turn from "@domchristie/turn";
Turn.config.experimental.viewTransitions = true
Turn.start()

// import ActiveStorage from "@rails/activestorage";
// ActiveStorage.start();
//
// // Import all channels.
// const channels = import.meta.globEager('./**/*_channel.js')

// Example: Import a stylesheet in app/frontend/index.css
import "../../assets/stylesheets/application.tailwind.css";

import "~/controllers";
