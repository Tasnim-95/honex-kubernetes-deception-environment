#!/bin/bash

echo "[+] Starting Attendance Node..."

service ssh start
service rsyslog start
service cron start

echo "[+] Waiting for attendance database..."

until nc -z mysql-attendance 3306
do
  sleep 3
done

echo "[+] Database reachable"

(
  while true; do
    echo "$(date) INFO Daily attendance sync completed" >> /var/log/attendance/attendance.log
    echo "$(date) INFO Uploading logs to central HR" >> /opt/attendance/logs/system.log
    sleep 60
  done
) &

# Hide container traces
mount -t tmpfs tmpfs /.dockerenv 2>/dev/null || true
echo "0::/" > /proc/1/cgroup 2>/dev/null || true

exec java -jar /opt/attendance/app.jar

