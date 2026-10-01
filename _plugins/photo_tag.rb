require "cgi"
require "date"
require "json"
require "net/http"
require "uri"

# = PhotoTag — Liquid tag embedding a photo or video from the jiggle photo site
#
#   {% photo 5d269350738b %}
#
# At build time, fetches <tt>JIGGLE_URL/p/ID/embed.json</tt> and renders a
# photo (an <img> linked to its page) or a video (a <video> with a link to its
# page below).  Each id is fetched at most once per build.
#
# == Configuration
#
# The base URL comes from <tt>_config.yml</tt>:
#
#   jiggle_url: https://photos.rjbs.cloud
#
# The +JIGGLE_URL+ environment variable overrides it.  A <tt>file://</tt> URL
# reads embed.json files from a local copy of the site instead of fetching
# them, which is handy before a sync.  The URLs inside embed.json are used
# as-is either way.
#
# == Failure
#
# Any failure (missing photo, bad JSON, unknown format, site down) raises,
# naming the id and the page, so the build fails rather than rendering nothing.
module Jekyll
  class PhotoTag < Liquid::Tag
    ID_RE = /\A[0-9a-f]+\z/

    # Embeds are fit within this box, like Flickr's "_c" size used by older
    # posts, so a portrait photo isn't a full screen tall.
    MAX_EDGE = 800

    @cache = {}
    class << self
      attr_reader :cache
    end

    def initialize(tag_name, markup, tokens)
      super
      @id = markup.strip
      unless @id.match?(ID_RE)
        raise SyntaxError, "photo tag needs a single hex photo id, got #{markup.inspect}"
      end
    end

    def render(context)
      site = context.registers[:site]
      page = context.registers[:page]
      data = self.class.cache[@id] ||= fetch(site)

      case data["type"]
      when "photo" then render_photo(data)
      when "video" then render_video(data)
      else raise "unknown type #{data["type"].inspect}"
      end
    rescue StandardError => e
      raise "photo #{@id} in #{page && page["path"]}: #{e.message}"
    end

    private

    def base_url(site)
      base = ENV["JIGGLE_URL"] || site.config["jiggle_url"]
      raise "no jiggle_url in _config.yml" unless base
      base.chomp("/")
    end

    def fetch(site)
      uri = URI("#{base_url(site)}/p/#{@id}/embed.json")

      body =
        if uri.scheme == "file"
          File.read(uri.path)
        else
          res = Net::HTTP.get_response(uri)
          raise "GET #{uri}: #{res.code} #{res.message}" unless res.is_a?(Net::HTTPSuccess)
          res.body
        end

      data = JSON.parse(body)
      unless data["format"] == 1
        raise "#{uri}: unknown embed format #{data["format"].inspect}"
      end
      data
    end

    def fit(width, height)
      scale = [1.0, MAX_EDGE.to_f / [width, height].max].min
      [(width * scale).round, (height * scale).round]
    end

    def h(str) = CGI.escapeHTML(str.to_s)

    def render_photo(data)
      renditions = data["renditions"]
      main = renditions.fetch("1024.webp")
      width, height = fit(main["width"], main["height"])

      srcset = renditions.values
        .sort_by { |r| r["width"] }
        .map { |r| "#{r["url"]} #{r["width"]}w" }
        .join(", ")

      %(<a class="jiggle-embed" href="#{h data["url"]}">) +
        %(<img src="#{h main["url"]}" srcset="#{h srcset}" sizes="(max-width: 840px) 100vw, #{width}px") +
        %( width="#{width}" height="#{height}" alt="#{h data["alt"]}" loading="lazy">) +
        caption(data) + %(</a>)
    end

    # The hover caption, as on the grid tiles on the jiggle site.  The name
    # line is the alt text, which is the date taken for an untitled photo, so
    # the date only gets its own line when there's a title.  It's aria-hidden
    # because the img's alt already says the same thing.
    def caption(data)
      details = data["title"].to_s.empty? ? nil : taken_date(data["taken"])

      %(<span class="caption" aria-hidden="true">) +
        %(<span class="name">#{h data["alt"]}</span>) +
        (details ? %(<span class="details">#{h details}</span>) : "") +
        %(</span>)
    end

    # The date part of a TOML datetime, like "16 July 2026".  Any offset is
    # ignored, since the date as it was where the photo was taken is the one
    # we want. -- claude, 2026-09-30
    def taken_date(taken)
      return nil unless taken
      m = taken.to_s.match(/\A(\d{4})-(\d\d)-(\d\d)/) or return nil
      Date.new(m[1].to_i, m[2].to_i, m[3].to_i).strftime("%-d %B %Y")
    end

    def render_video(data)
      video  = data.fetch("video")
      poster = data["renditions"].fetch("2048.webp")
      width, height = fit(video["width"], video["height"])

      %(<span class="jiggle-embed jiggle-video">) +
        %(<video controls preload="metadata" playsinline width="#{width}" height="#{height}") +
        %( poster="#{h poster["url"]}" title="#{h data["alt"]}">) +
        %(<source src="#{h video["url"]}" type="video/mp4"></video>) +
        %(<a href="#{h data["url"]}">#{h data["alt"]}</a></span>)
    end
  end
end

Jekyll::Hooks.register :site, :after_reset do
  Jekyll::PhotoTag.cache.clear
end

Liquid::Template.register_tag("photo", Jekyll::PhotoTag)
