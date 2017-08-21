{% set GOPATH = '/data/go_work' %}
{% set FILENAME = 'cmbcs.tar.gz' %}
{% set COMMANDDIR = GOPATH + '/src/cmbcs' %}
{% set APPUSER = 'cmbcs' %}
{% set APPGROUP = 'cmbcs' %}

app-base-clear:
  file.absent:
    - name: {{ COMMANDDIR }}

app-base-directory:
  file.directory:
    - name: {{ COMMANDDIR }}
    - user: cmbcs
    - group: cmbcs
    - mode: 755
    - require:
      - file: app-base-clear

app-file:
  file.managed:
    - name: {{ COMMANDDIR }}/{{ FILENAME }}
    - source: salt://files/{{ FILENAME }}
    - user: {{ APPUSER }}
    - group: {{ APPGROUP }}
    - mode: 755
    - require:
      - file: app-base-directory
  cmd.run:
    - name: cd {{ COMMANDDIR }} && tar zxvf {{ FILENAME }} && chown {{ APPUSER }}.{{ APPGROUP }} -R {{ COMMANDDIR }} && rm -f {{ FILENAME }}
    - require:
      - file: app-file
