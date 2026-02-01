---
layout: default
title: Talks
---

I present talks and tutorials about programming, UNIX, and other topics.  You
can see some of them below.  Videos are generally better than slides, because
the slides are much less informative without me narrating and gesticulating
wildly.  Ask me to come speak for your group!

<div class="talks-grid">
{% assign sorted_talks = site.talks | sort: 'date' | reverse %}
{% for talk in sorted_talks %}
  {% assign first_url = talk.urls.first.url | default: '#' %}
  <div class="talk-card">
    {% assign talk_dir = talk.path | remove: '_talks/' | remove: 'index.md' %}
    {% if talk.image %}
      <a href="{{ first_url }}">
        <img class="talk-image" src="{{ talk.image }}" alt="{{ talk.title }}">
      </a>
    {% else %}
      {% assign image_path = '/talks/' | append: talk_dir | append: "preview.jpg" %}
      <a href="{{ first_url }}">
        <object class="talk-image" data="{{ image_path }}">
        </object>
      </a>
    {% endif %}
    <div class="talk-content">
      <div class="talk-title"><a href="{{ first_url }}">{{ talk.title }}</a></div>
      <div class="talk-description">{{ talk.description }}</div>
      <div class="talk-links">
        {% for link in talk.urls %}
          <a href="{{ link.url }}">{{ link.label }}</a>
        {% endfor %}
      </div>
    </div>
  </div>
{% endfor %}
</div>
