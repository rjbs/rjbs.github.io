require "cgi"

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
