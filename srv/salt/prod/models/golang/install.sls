{% set GOPATH = '/data/go_work' %}

golang-install:
  pkg.installed:
    - name: golang
    - unless: rpm -qa | grep golang

golang-gopath:
  file.directory:
    - name: {{ GOPATH }}/src
    - mode: 755
    - user: cmbcs
    - group: cmbcs
    - makedirs: True
    - require:
      - pkg: golang-install

golang-profile:
  file.managed:
    - name: /etc/profile.d/golang.sh
    - source: salt://models/golang/files/golang.profile
    - user: root
    - group: root
    - mode: 664
    - template: jinja
    - defaults:
      GOPATH: {{ GOPATH }}
    - require:
      - file: golang-gopath
  cmd.run:
    - name: source /etc/profile
    - requeire:
      - file: golang-profile
    - watch:
      - file: golang-profile
