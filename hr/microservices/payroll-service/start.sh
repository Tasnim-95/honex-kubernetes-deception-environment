#!/bin/bash

echo "[+] Starting Payroll Node..."

service ssh start
service rsyslog start
service cron start

echo "[+] Waiting for payroll database..."

until nc -z mysql-payroll 3306
do
  sleep 3
done

echo "[+] Database reachable"

(
  while true; do
    echo "$(date) INFO Payroll batch processed" >> /opt/payroll/logs/system.log
    echo "$(date) INFO Encrypted backup stored" >> /opt/payroll/logs/system.log
    sleep 60
  done
) &

# Hide container traces
mount -t tmpfs tmpfs /.dockerenv 2>/dev/null || true
echo "0::/" > /proc/1/cgroup 2>/dev/null || true

exec java -jar /opt/payroll/app.jar
