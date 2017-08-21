jemalloc-install:
  file.managed:
    - name: /usr/local/src/jemalloc-4.4.0.tar.bz2
    - source: salt://models/jemalloc/files/jemalloc-4.4.0.tar.bz2
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd /usr/local/src/ && tar jxf jemalloc-4.4.0.tar.bz2 && cd jemalloc-4.4.0 && ./configure && make && make install
    - require:
      - file: jemalloc-install

jemalloc-conf:
  file.managed:
    - name: /etc/ld.so.conf.d/local.conf
    - source: salt://models/jemalloc/files/local.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: jemalloc-install
  cmd.run:
    - name: ldconfig
    - require:
      - file: jemalloc-conf
    - watcha:
      - file: jemalloc-conf
