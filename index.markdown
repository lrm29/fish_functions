---
title: fish_functions
layout: default
---

# Tips and Tricks

{% for post in site.posts %}
  <span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ post.url }}">{{ post.title }}</a><br>
{% endfor %}
