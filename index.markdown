---
title: fish_functions
layout: default
---

<h3>Tips and Tricks</h3>

{% for post in site.posts %}
  <span>{{ post.date | date_to_string }}</span> &raquo; <a href="http://lrm29.github.com/fish_functions/{{ post.url }}">{{ post.title }}</a><br>
{% endfor %}
