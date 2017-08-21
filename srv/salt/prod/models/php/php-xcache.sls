xcache-plugin:
  file.managed:
    - name: /usr/local/src/xcache-3.2.0.tar.gz
    - source: salt://models/php/files/xcache-3.2.0.tar.gz
    - user: root
    - group: root
    - mode: 755

  cmd.run:
    - name: cd /usr/local/src && tar zxf xcache-3.2.0.tar.gz && cd xcache-3.2.0 && /usr/local/php-fastcgi/bin/phpize && ./configure --enable-xcache --with-php-config=/usr/local/php-fastcgi/bin/php-config &&  make&& make install
    - unless: test -f /usr/local/php-fastcgi/lib/php/extensions/*/xcache.so
  require:
    - file: xcache-plugin
    - cmd: php-source-install

/usr/local/php-fastcgi/etc/php.ini:
  file.append:
    - text:
      - extension=xcache.so
    - require:
      - cmd: xcache-plugin

