include:
  - models.pkg.pkg-init
  - models.jemalloc.install
  - models.user.www

nginx-install:
  file.managed:
    - name: /usr/local/src/nginx-1.10.2.tar.gz
    - source: salt://models/nginx/files/nginx-1.10.2.tar.gz
    - user: root
    - group: root
    - mode: 644
    - require:
      - user: www-user-create
  cmd.run:
    - name: cd /usr/local/src/ && tar zxf nginx-1.10.2.tar.gz && cd nginx-1.10.2 && ./configure --prefix=/usr/local/nginx --user=www --group=www --with-http_stub_status_module --with-http_v2_module --with-http_ssl_module --with-http_gzip_static_module --with-http_realip_module --with-http_flv_module --with-http_mp4_module --with-pcre --with-pcre-jit --with-ld-opt='-ljemalloc' && make && make install
    - require:
      - file: nginx-install

nginx-init:
  file.managed:
    - name: /etc/init.d/nginx
    - source: salt://models/nginx/files/nginx.ini
    - user: root
    - group: root
    - mode: 755
    - require:
      - cmd: nginx-install
  cmd.run:
    - name: chkconfig --add nginx
    - unless: chkconfig --list | grep nginx
    - require:
      - file: nginx-init

nginx-proxy:
  file.managed:
    - name: /usr/local/nginx/conf/proxy.conf
    - source: salt://models/nginx/files/proxy.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: nginx-install

nginx-conf:
  file.managed:
    - name: /usr/local/nginx/conf/nginx.conf
    - source: salt://models/nginx/files/nginx.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: nginx-proxy

nginx-vhost-directory:
  file.directory:
    - name: /usr/local/nginx/conf/vhost
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - require:
      - file: nginx-conf
