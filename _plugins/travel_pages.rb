# Generates one page per travel location at /travel/<id>/, showing a map of
# just that place along with its description, links, and any blog posts that
# join to it via `location:`. The /travel/ map index still exists (travel.md).
# The location ids in _data/maps/travel.yaml are already URL-safe slugs, so
# they are used verbatim as the path segment. -- claude, 2026-07-04

module TravelPages
  class Generator < Jekyll::Generator
    safe true

    def generate(site)
      dir    = site.config["travel_dir"] || "travel"
      places = site.data.dig("maps", "travel") || {}

      places.each_key do |id|
        site.pages << PlacePage.new(site, site.source, File.join(dir, id), id, places[id])
      end
    end
  end

  class PlacePage < Jekyll::Page
    def initialize(site, base, dir, id, place)
      @site = site
      @base = base
      @dir  = dir
      @name = "index.html"

      process(@name)
      read_yaml(File.join(base, "_layouts"), "travel_place.html")

      data["place_id"] = id
      data["title"]    = place["title"] || id
    end
  end
end
