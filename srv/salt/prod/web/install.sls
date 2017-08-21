include:
  - models.nginx.install
  - models.php.install

service-start-php:
  service.running:
    - name: php-fpm
    - enable: True
    - reload: True
    - require:
      - cmd: php-fastcgi-service

nginx-vhost-conf:
  file.managed:
    - name: /usr/local/nginx/conf/vhost/cmbcs.cn.conf
    - source: salt://web/files/cmbcs.cn.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - service: service-start-php

service-start-nginx:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - require:
      - file: nginx-vhost-conf
    - watch:
      - file: nginx-vhost-conf
