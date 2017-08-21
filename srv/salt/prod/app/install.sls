{% set GOPATH = '/data/go_work' %}
{% set FILENAME = 'cmbcs.tar.gz' %}
{% set COMMANDDIR = GOPATH + '/src/cmbcs' %}
{% set APPNAME = 'cmbcs' %}
{% set APPUSER = 'cmbcs' %}
{% set APPGROUP = 'cmbcs' %}

include:
  - models.ssh.init
  - models.pkg.pkg-init
  - models.golang.install
  - models.supervisor.install

app-directory:
  file.directory:
    - name: {{ COMMANDDIR }}
    - user: {{ APPUSER }}
    - group: {{ APPGROUP }}
    - makedirs: True
    - mode: 755

app-file:
  file.managed:
    - name: {{ COMMANDDIR }}/{{ FILENAME }}
    - source: salt://app/files/{{ FILENAME }}
    - user: {{ APPUSER }}
    - group: {{ APPGROUP }}
    - mode: 755
    - require:
      - file: app-directory
  cmd.run:
    - name: cd {{ COMMANDDIR }} && tar zxvf {{ FILENAME }} && chown {{ APPUSER }}.{{ APPGROUP }} -R {{ COMMANDDIR }}  && rm -f {{ FILENAME }}

app-supervisor:
  file.managed:
    - name: /etc/supervisor.d/{{ APPNAME }}.ini
    - source: salt://app/files/{{ APPNAME }}.ini
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      appname: {{ APPNAME }}
      command: {{ COMMANDDIR }}/{{ APPNAME }}
      directory: {{ COMMANDDIR }}
      user: {{ APPUSER }}
      logs: {{ COMMANDDIR }}/logs/message.log
    - require:
      - cmd: app-file
  service.running:
    - name: supervisord
    - enable: True
    - reload: True
    - watch:
      - file: app-supervisor
    - require:
      - file: app-supervisor
