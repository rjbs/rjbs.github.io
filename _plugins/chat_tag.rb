require "cgi"

# = ChatBlock — Liquid block tag for chat/dialogue transcripts
#
# Renders an IRC/Slack-style conversation as styled HTML. Each line of the
# block is either a speaker line, a stage direction, or a blank line.
#
# == Basic usage
#
#   {% chat %}
#   Alice: Hey, how's it going?
#   Bob: Pretty well, thanks!
#   {% endchat %}
#
# == Line types
#
# Speaker line:: <tt>Name: text</tt> — the speaker's name and their words.
#   Markdown is rendered in the text. Speaker names are matched
#   case-insensitively for color lookup but displayed as written.
#
# Stage direction:: <tt>* text</tt> — rendered centered and italicized,
#   suitable for narration, time skips, etc.
#
#   * time passes
#
# Continuation:: A line indented with any leading whitespace is folded onto
#   the preceding line, allowing long lines to be wrapped at 80 columns.
#
#   Alice: This is a longer message that I'd
#     like to wrap neatly in my source file.
#
# Blank lines are ignored. Any other line raises a SyntaxError at build time.
#
# == Speaker colors
#
# Colors are resolved in priority order:
#
# 1. Inline tag parameter (single-token names only):
#
#      {% chat Alice="#005ab4" Bob="#6b1818" %}
#
# 2. Global config in <tt>_config.yml</tt>:
#
#      chat:
#        speakers:
#          Alice: "#005ab4"
#          Bob:   "#6b1818"
#
# 3. Automatic assignment from the palette (see below).
#
# Speaker name matching is case-insensitive, so "Alice", "alice", and "ALICE"
# all resolve to the same configured color.
#
# == Palette
#
# Speakers with no configured color are assigned colors from the palette in
# order of first appearance. The built-in palette can be overridden in
# <tt>_config.yml</tt>:
#
#   chat:
#     palette:
#       - "#005ab4"
#       - "#6b1818"
#       - "#2a7a2a"
#
module Jekyll
  class ChatBlock < Liquid::Block
    SPEAKER_LINE = /\A([^:]+?):\s+(.*)\z/m

    # Fallback palette used when a speaker has no configured color.
    # Can be overridden via chat.palette in _config.yml.
    DEFAULT_PALETTE = %w[#005ab4 #6b1818 #2a7a2a #880088 #c05800 #2a6a8a].freeze

    def initialize(tag_name, markup, tokens)
      super
      @inline_colors = parse_inline_colors(markup)
    end

    def render(context)
      content   = super.strip
      site      = context.registers[:site]
      converter = site.find_converter_instance(Jekyll::Converters::Markdown)

      chat_config    = site.config["chat"] || {}
      global_colors  = (chat_config["speakers"] || {}).transform_keys { |k| k.to_s.downcase }
      palette        = chat_config["palette"] || DEFAULT_PALETTE

      # Per-tag inline colors override global config; all keys lowercased for lookup
      speaker_colors = global_colors.merge(@inline_colors.transform_keys(&:downcase))

      # Track palette position for speakers with no explicit color
      auto_colors  = {}
      palette_pos  = 0

      lines = content.split("\n").each_with_object([]) do |line, acc|
        if line.match?(/\A\s/) && !acc.empty?
          acc.last << " " << line.strip
        elsif !line.strip.empty?
          acc << line.strip
        end
      end

      html_lines = lines.map do |line|
        if line.start_with?("* ")
          text = line[2..].strip
          %(<div class="chat-direction">#{inline_md(converter, text)}</div>)

        elsif (m = line.match(SPEAKER_LINE))
          speaker = m[1].strip
          text    = m[2].strip

          color = speaker_colors[speaker.downcase] || begin
            auto_colors[speaker.downcase] ||= palette[palette_pos % palette.length].tap { palette_pos += 1 }
          end

          safe_name  = CGI.escapeHTML(speaker)
          safe_color = CGI.escapeHTML(color.to_s)
          %(<div class="chat-line" style="--speaker-color: #{safe_color}"><span class="chat-speaker-name">#{safe_name}</span><span class="chat-text">#{inline_md(converter, text)}</span></div>)

        else
          raise SyntaxError, "chat block: unrecognized line: #{line.inspect}"
        end
      end

      %(<div class="chat-transcript">\n#{html_lines.join("\n")}\n</div>)
    end

    private

    # Parse   SomeName="#hexcolor"   pairs from the tag markup.
    # Names must be single tokens (no spaces); use _config.yml chat.speakers for
    # names with spaces.
    def parse_inline_colors(markup)
      colors = {}
      markup.scan(/(\S+?)="(#[0-9a-fA-F]{3,6})"/) { |name, color| colors[name] = color }
      colors
    end

    def inline_md(converter, text)
      html = converter.convert(text).strip
      html.sub(/\A<p>/, "").sub(/<\/p>\s*\z/, "")
    end
  end
end

Liquid::Template.register_tag("chat", Jekyll::ChatBlock)
