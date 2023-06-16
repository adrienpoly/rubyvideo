import { defineConfig } from "vite";
import RubyPlugin from "vite-plugin-ruby";
import StimulusHMR from "vite-plugin-stimulus-hmr";
import FullReload from "vite-plugin-full-reload";

export default defineConfig({
  plugins: [
    RubyPlugin(),
    StimulusHMR(),
    FullReload([
      "config/routes.rb",
      "app/views/**/*",
      "app/controllers/**/*",
      "app/models/**/*",
    ]),
  ],
});
