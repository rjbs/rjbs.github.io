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
{% assign sorted_talks = site.talks | sort: 'date' | reverse %}
{% for talk in sorted_talks %}
  <div class="talk-card">
    {% assign talk_dir = talk.path | remove: '_talks/' | remove: 'index.md' %}
    {% if talk.image %}
      <a href="{{ talk.slides_url | default: talk.video_url | default: '#' }}">
        <img class="talk-image" src="{{ talk.image }}" alt="{{ talk.title }}">
      </a>
    {% else %}
      {% assign image_path = '/talks/' | append: talk_dir | append: "preview.jpg" %}
      <a href="{{ talk.slides_url | default: talk.video_url | default: '#' }}">
        <object class="talk-image" data="{{ image_path }}">
        </object>
      </a>
    {% endif %}
    <div class="talk-content">
      <div class="talk-title"><a href="{{ talk.slides_url | default: talk.video_url }}">{{ talk.title }}</a></div>
      <div class="talk-description">{{ talk.description }}</div>
      <div class="talk-links">
        {% if talk.video_url %}<a href="{{ talk.video_url }}">Video</a>{% endif %}
        {% if talk.slides_url %}<a href="{{ talk.slides_url }}">Slides</a>{% endif %}
      </div>
    </div>
  </div>
{% endfor %}
</div>
