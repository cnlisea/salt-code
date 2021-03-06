supervisor-tools:
  pkg.installed:
    - name: python-setuptools

supervisor-install:
  file.managed:
    - name: /usr/local/src/supervisor-3.3.1.tar.gz
    - source: salt://models/supervisor/files/supervisor-3.3.1.tar.gz
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd /usr/local/src && tar zxf supervisor-3.3.1.tar.gz && cd supervisor-3.3.1 && python setup.py install 

supervisor-conf:
  file.managed:
    - name: /etc/supervisord.conf
    - source: salt://models/supervisor/files/supervisord.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: supervisor-install

supervisor-ini-directory:
  file.directory:
    - name: /etc/supervisor.d
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: supervisor-conf

supervisor-service:
  file.managed:
    - name: /etc/init.d/supervisord
    - source: salt://models/supervisor/files/supervisord.ini
    - user: root
    - group: root
    - mode: 755
    - require:
      - cmd: supervisor-install
  cmd.run:
    - name: chkconfig --add supervisord && chkconfig supervisord on
    - unless: chkconfig --list | grep supervisord
    - require:
      - file: supervisor-service
