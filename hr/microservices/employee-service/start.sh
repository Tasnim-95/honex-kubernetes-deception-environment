#!/bin/bash

echo "[+] Starting enterprise HR node..."

service ssh start
service rsyslog start
service cron start

echo "[+] Waiting for employee database..."

until nc -z mysql-employee 3306
do
  sleep 3
done

echo "[+] Database reachable"

(
  while true; do
    echo "$(date) INFO Employee sync completed" >> /opt/hr-system/logs/system.log
    echo "$(date) INFO HR batch job executed" >> /opt/hr-system/logs/hr.log
    sleep 60
  done
) &

# Hide container traces
mount -t tmpfs tmpfs /.dockerenv 2>/dev/null || true
echo "0::/" > /proc/1/cgroup 2>/dev/null || true

exec java -jar /opt/hr-system/app.jar

