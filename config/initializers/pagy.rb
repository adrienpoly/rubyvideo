require "pagy/extras/meilisearch"
require "pagy/extras/overflow"
require "pagy/extras/gearbox"

Pagy::DEFAULT[:overflow] = :last_page
Pagy::DEFAULT[:gearbox_extra] = false
