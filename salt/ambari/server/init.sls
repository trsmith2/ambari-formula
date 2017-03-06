{% from 'ambari/map.jinja' import ambari with context %}
{% from 'ambari/map.jinja' import version_mapping with context %}

# Sets which user is running ambari-server
{% set ambari_user = ambari.server.ambari_server.user %}

include:
  - ambari.repo
  {% if ambari.server.start_service %}
  - ambari.server.service
  {% endif %}

{% if salt['grains.get']('os_family') == 'RedHat' %}
ambari-server-{{ambari.version}}-pkg:
  pkg.latest:
    - name: ambari-server
    - fromrepo: ambari-{{ ambari.version }}
    - version: {{ ambari.version }}
{% endif %}

{% if salt['grains.get']('os_family') == 'Debian' %}
ambari-server-{{ambari.version}}-pkg:
  pkg.installed:
    - name: ambari-server
    - fromrepo: Ambari
    - version: {{ version_mapping.get(ambari.version) }}
{% endif %}

