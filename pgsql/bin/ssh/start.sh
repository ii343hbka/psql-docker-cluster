#!/usr/bin/env bash

echo '[ssh/start] Tuning up sshd...'
chown -R postgres:postgres /home/postgres
chmod 700 /home/postgres/.ssh
chmod 600 /home/postgres/.ssh/id_rsa

echo '[ssh/start] Starting...'
/usr/sbin/sshd -D &