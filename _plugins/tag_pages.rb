# Generates one page per tag at /tags/<slug>/, listing every post that carries
# the tag. The big /tags/ index still exists (tags.html); these pages are for
# direct linking and comfortable scrolling of a single tag. -- claude, 2026-07-04

module TagPages
  class Generator < Jekyll::Generator
    safe true

    def generate(site)
      dir = site.config["tag_dir"] || "tags"

      site.tags.each_key do |tag|
        slug = Jekyll::Utils.slugify(tag)
        site.pages << TagPage.new(site, site.source, File.join(dir, slug), tag)
      end
    end
  end

  class TagPage < Jekyll::Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir  = dir
      @name = "index.html"

      process(@name)
      read_yaml(File.join(base, "_layouts"), "tag_index.html")

      data["tag"]   = tag
      data["title"] = "Tag: #{tag}"
    end
  end
end
