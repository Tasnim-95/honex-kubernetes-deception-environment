#!/bin/bash
set -euxo pipefail

echo "[+] Booting HONEX HR Workstation"

# ==============================
# Required ENV (fail if missing)
# ==============================
: "${USERNAME:?USERNAME not set}"
: "${ROLE:?ROLE not set}"
: "${HOSTNAME:?HOSTNAME not set}"
: "${OPEN_PORT:?OPEN_PORT not set}"
: "${TARGET_SERVICE:?TARGET_SERVICE not set}"

# ==============================
# Host identity (cosmetic but realistic)
# ==============================
echo "$HOSTNAME" > /etc/hostname || true
hostname "$HOSTNAME" || true
echo "$ROLE" > /etc/workstation.role

# ==============================
# Create single human user
# ==============================
useradd -m -s /bin/bash "$USERNAME" || true
echo "${USERNAME}:Welcome123" | chpasswd

HOME_DIR="/home/$USERNAME"
mkdir -p \
  "$HOME_DIR/Documents" \
  "$HOME_DIR/Downloads" \
  "$HOME_DIR/.cache/outlook" \
  "$HOME_DIR/.mozilla/firefox/profile.default"

# ==============================
# Role-based realistic artifacts
# ==============================
case "$ROLE" in
  RECRUITER)
    echo "CV: Ahmed Hassan" > "$HOME_DIR/Documents/cv_$(date +%s).txt"
    echo "Interview notes: Good communication skills" > "$HOME_DIR/Documents/interview_notes.txt"
    cat > "$HOME_DIR/.mozilla/firefox/profile.default/places.sqlite" <<EOF
http://hr-portal.honex.local
http://careers.honex.local
http://mail.honex.local
EOF
    cat > "$HOME_DIR/.cache/outlook/inbox.db" <<EOF
From: hr.manager@honex.local
Subject: New candidate CV attached
EOF
    ;;
  CLERK)
    echo "EMP1001,PRESENT" > "$HOME_DIR/Documents/attendance_$(date +%s).csv"
    echo "Send attendance before 5PM" > "$HOME_DIR/Documents/todo_$(date +%s).txt"
    cat > "$HOME_DIR/.mozilla/firefox/profile.default/places.sqlite" <<EOF
http://attendance.honex.local
http://intranet.honex.local
http://mail.honex.local
EOF
    cat > "$HOME_DIR/.cache/outlook/inbox.db" <<EOF
From: hr.manager@honex.local
Subject: Attendance reminder
EOF
    ;;
  PAYROLL)
    echo "EMP202 SALARY=9000" > "$HOME_DIR/Documents/payroll_preview_$(date +%s).txt"
    echo "pay_user=payrollsvc" > "$HOME_DIR/Documents/pay_creds_$(date +%s).txt"
    cat > "$HOME_DIR/.mozilla/firefox/profile.default/places.sqlite" <<EOF
http://payroll.honex.local
http://finance.honex.local
http://mail.honex.local
EOF
    cat > "$HOME_DIR/.cache/outlook/inbox.db" <<EOF
From: finance.manager@honex.local
Subject: Payroll review
EOF
    ;;
  *)
    echo "Unknown ROLE: $ROLE"
    exit 1
    ;;
esac

# ==============================
# Make timestamps realistic
# ==============================
for f in "$HOME_DIR/Documents/"*; do
  days=$(( (RANDOM % 60) + 1 ))
  touch -d "$days days ago" "$f" || true
done

# ==============================
# Fake bash history (human-like)
# ==============================
cat > "$HOME_DIR/.bash_history" <<EOF
ls
cd Documents
ls
cat *
curl http://$TARGET_SERVICE
exit
EOF

# ==============================
# Background noise (fake processes)
# ==============================
bash -c "exec -a office-sync sleep 99999" &
bash -c "exec -a outlook-cache sleep 99999" &
bash -c "exec -a printer-agent sleep 99999" &

# ==============================
# Open one realistic listening port
# ==============================
nc -lkp "$OPEN_PORT" >/dev/null 2>&1 &

# ==============================
# Periodic internal traffic
# ==============================
(
  while true; do
    sleep $((300 + RANDOM % 200))
    curl -s "http://$TARGET_SERVICE" >/dev/null 2>&1 || true
  done
) &

# ==============================
# Permissions
# ==============================
chown -R "$USERNAME:$USERNAME" "$HOME_DIR"
chmod 700 "$HOME_DIR"

echo "[+] Workstation ready: $USERNAME ($ROLE)"

# ==============================
# Keep container alive
# ==============================
tail -f /dev/null

