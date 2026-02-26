module Jekyll
  class AsciinemaTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @path = markup.strip
    end

    def render(context)
      context.registers[:page]["asciinema"] = true
      <<~HTML
        <div id="#{@path}"></div>
        <script>
          AsciinemaPlayer.create(
            "#{@path}",
            document.getElementById("#{@path}"),
            { fit: "width" }
          );
        </script>
      HTML
    end
  end
end

Liquid::Template.register_tag("asciinema", Jekyll::AsciinemaTag)
