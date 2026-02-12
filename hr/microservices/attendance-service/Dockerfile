# ==============================
# Base Image
# ==============================
FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Africa/Cairo

# ==============================
# System + Java
# ==============================
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    tzdata \
    netcat-openbsd \
    curl wget ftp telnet \
    vim nano less \
    net-tools iputils-ping traceroute \
    procps lsof htop strace \
    openssh-server sudo \
    rsyslog cron logrotate \
    default-mysql-client postgresql-client \
    nmap tcpdump \
    zip unzip tar gzip \
    python3 python3-pip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ==============================
# Users
# ==============================
RUN useradd -m attendance && \
    useradd -m sysadmin && \
    useradd -m auditor && \
    echo "attendance:Attend@123" | chpasswd && \
    echo "sysadmin:P@ssw0rd" | chpasswd && \
    echo "auditor:Audit2022" | chpasswd && \
    usermod -aG sudo sysadmin

# ==============================
# Directories
# ==============================
RUN mkdir -p \
    /opt/attendance/logs \
    /opt/attendance/conf \
    /var/log/attendance \
    /data/attendance

# ==============================
# Fake Attendance Logs
# ==============================
RUN echo "2025-01-10 08:55 Mona Adel CHECK-IN" > /var/log/attendance/attendance.log && \
    echo "2025-01-10 17:02 Mona Adel CHECK-OUT" >> /var/log/attendance/attendance.log && \
    echo "2025-01-10 09:05 Omar Hassan CHECK-IN" >> /var/log/attendance/attendance.log

RUN echo "db.url=jdbc:mysql://attendance-db.internal:3306/attendance" > /opt/attendance/conf/application.properties && \
    echo "db.user=attendance_user" >> /opt/attendance/conf/application.properties && \
    echo "db.password=AttendDB@123" >> /opt/attendance/conf/application.properties

# ==============================
# Initial Logs
# ==============================
RUN echo "Attendance Service Boot Completed" > /opt/attendance/logs/system.log

# ==============================
# SSH
# ==============================
RUN mkdir /var/run/sshd && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# ==============================
# Command Logging
# ==============================
RUN echo 'export PROMPT_COMMAND='\''history -a; echo "$(date +"%F %T") | $(whoami) | $(pwd) | $(history 1)" >> /var/log/cmd.log'\''' >> /etc/bash.bashrc
RUN touch /var/log/cmd.log && chmod 666 /var/log/cmd.log

# ==============================
# Hide container traces
# ==============================
RUN rm -f /.dockerenv || true

# ==============================
# Banner
# ==============================
RUN echo "Authorized access only. Attendance Server." > /etc/motd

# ==============================
# App
# ==============================
WORKDIR /opt/attendance
COPY target/*.jar app.jar
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22
EXPOSE 8083

CMD ["/start.sh"]

