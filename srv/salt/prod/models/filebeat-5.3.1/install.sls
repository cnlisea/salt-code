filebeat-file:
  file.managed:
    - name: /usr/local/src/filebeat-5.3.1-linux-x86_64.tar.gz
    - source: salt://models/filebeat-5.3.1/files/filebeat-5.3.1-linux-x86_64.tar.gz
    - user: root
    - group: root
    - mode: 644
