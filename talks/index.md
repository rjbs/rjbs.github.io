---
layout: default
title: Talks
---

I present talks and tutorials about programming, UNIX, and other topics.  I've
published most of my slides, although they're much less informative without me
narrating and gesticulating wildly.  Ask me to come speak for your group!  If I
can make it to your public group, I'd love to come.  I'm also available for
professional instruction.

My long form talk on Moose, [Moose is Perl: A Guide to the New
Revolution](/talks/moose) is available on its own page.

<div class="talks-grid">
{% for talk in site.data.talks %}
  <div class="talk-card">
    {% if talk.image %}
      <a href="{{ talk.slides_url | default: talk.video_url }}">
        <img class="talk-image" src="{{ talk.image }}" alt="{{ talk.title }}">
      </a>
    {% endif %}
    <div class="talk-content">
      <div class="talk-title">{{ talk.title }}</div>
      <div class="talk-description">{{ talk.description }}</div>
      <div class="talk-links">
        {% if talk.video_url %}<a href="{{ talk.video_url }}">Video</a>{% endif %}
        {% if talk.slides_url %}<a href="{{ talk.slides_url }}">Slides</a>{% endif %}
      </div>
    </div>
  </div>
{% endfor %}
</div>
