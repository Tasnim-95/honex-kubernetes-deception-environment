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
    openssl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ==============================
# Users
# ==============================
RUN useradd -m payrollsvc && \
    useradd -m sysadmin && \
    useradd -m auditor && \
    echo "payrollsvc:Payr0ll@123" | chpasswd && \
    echo "sysadmin:P@ssw0rd" | chpasswd && \
    echo "auditor:Audit2022" | chpasswd && \
    usermod -aG sudo sysadmin

# ==============================
# Directories
# ==============================
RUN mkdir -p \
    /opt/payroll/logs \
    /opt/payroll/conf \
    /data/payroll/backups \
    /data/payroll/keys \
    /var/company/finance

# ==============================
# Fake Payroll Data
# ==============================
RUN echo "emp_id,name,salary,bank_account" > /data/payroll/backups/payroll_2025.csv && \
    echo "1001,Sara Ali,14000,EG12000123456789" >> /data/payroll/backups/payroll_2025.csv && \
    echo "1002,Omar Hassan,18000,EG23000987654321" >> /data/payroll/backups/payroll_2025.csv && \
    echo "1003,Mona Adel,16500,EG56000765432198" >> /data/payroll/backups/payroll_2025.csv

# ==============================
# Fake Encryption Keys
# ==============================
RUN echo "PAYROLL_MASTER_KEY=9f82a7bca9012ee123" > /data/payroll/keys/master.key && \
    echo "BACKUP_ENCRYPTION_KEY=enc-key-778899" >> /data/payroll/keys/master.key

# ==============================
# Fake Config
# ==============================
RUN echo "db.url=jdbc:mysql://payroll-db.internal:3306/payroll" > /opt/payroll/conf/application.properties && \
    echo "db.user=payroll_user" >> /opt/payroll/conf/application.properties && \
    echo "db.password=PayrollDB@123" >> /opt/payroll/conf/application.properties && \
    echo "encryption.key.file=/data/payroll/keys/master.key" >> /opt/payroll/conf/application.properties

# ==============================
# Initial Logs
# ==============================
RUN echo "Payroll Service Started" > /opt/payroll/logs/system.log && \
    echo "Last backup created successfully" >> /opt/payroll/logs/system.log

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
# Hide Container Traces
# ==============================
RUN rm -f /.dockerenv || true

# ==============================
# Banner
# ==============================
RUN echo "Authorized access only. Payroll Server." > /etc/motd

# ==============================
# App
# ==============================
WORKDIR /opt/payroll
COPY target/*.jar app.jar
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22
EXPOSE 8084

CMD ["/start.sh"]

