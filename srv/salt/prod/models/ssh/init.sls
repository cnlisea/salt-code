user_create: 
  user.present:
    - name: cmbcs
    - shell: /bin/bash
    - home: /home/cmbcs

authorized-directory:
  file.directory:
    - name: /home/cmbcs/.ssh
    - user: cmbcs
    - group: cmbcs
    - mode: 755
    - require:
      - user: user_create

authorized:
  file.managed:
    - name: /home/cmbcs/.ssh/authorized_keys
    - source: salt://models/ssh/files/id_rsa.pub
    - user: cmbcs
    - group: cmbcs
    - mode: 600
    - require:
      - file: authorized-directory

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://models/ssh/files/sshd_config
    - user: root
    - group: root
    - mode: 600
    - require:
      - file: authorized

sshd-conf:
    service.running:
    - name: sshd
    - enable: True
    - reload: True
    - watch:
      - file: /etc/ssh/sshd_config
    - require:
      - file: authorized
