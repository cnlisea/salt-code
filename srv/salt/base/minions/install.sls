{% set master_ip4 = '172.18.240.1' %}

yum-repo-update:
  file.managed:
    - name: /etc/yum.repos.d/epel.repo
    {% if '6' == grains['osmajorrelease'] %}
    - source: salt://minions/yum.repos.d/epel-6.repo
    {% elif '7' == grains['osmajorrelease'] %}
    - source: salt://minions/yum.repos.d/epel-7.repo
    {% endif %}
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: 'yum makecache && yum update -y'
    - require:
      - file: yum-repo-update

salt-minion-install:
  pkg.installed:
    - name: salt-minion
    - require:
      - cmd: yum-repo-update
    - unless: rpm -qa | grep salt-minion
  cmd.run:
    {% if '6' == grains['osmajorrelease'] %}
    - name: chkconfig --add salt-minion && chkconfig salt-minion on
    {% elif '7' == grains['osmajorrelease'] %}
    - name: systemctl enable salt-minion
    {% endif %}
    - unless: chkconfig --list | grep salt-minion
    - require: 
      - pkg: salt-minion-install 

salt-minion-conf:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://minions/conf/minion
    - template: jinja
    - defaults:
      SERVER_IP4: {{ master_ip4 }}
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: salt-minion-install
  service.running:
    - name: salt-minion
    - enable: True
    - reload: True
    - reqeuire:
      - file: salt-minion-install
    - watch:
      - file: salt-minion-conf
