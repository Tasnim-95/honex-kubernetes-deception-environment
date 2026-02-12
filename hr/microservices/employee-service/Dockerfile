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
RUN useradd -m hradmin && \
    useradd -m sysadmin && \
    useradd -m auditor && \
    echo "hradmin:Welcome123" | chpasswd && \
    echo "sysadmin:P@ssw0rd" | chpasswd && \
    echo "auditor:Audit2022" | chpasswd && \
    usermod -aG sudo sysadmin

# ==============================
# Directories
# ==============================
RUN mkdir -p \
    /opt/hr-system/logs \
    /opt/hr-system/conf \
    /data/employees \
    /var/company/docs

# ==============================
# HR Fake Data
# ==============================
RUN echo "id,name,department,role" > /data/employees/employees.csv && \
    echo "1001,Sara Ali,HR,Officer" >> /data/employees/employees.csv && \
    echo "1002,Omar Hassan,Finance,Accountant" >> /data/employees/employees.csv && \
    echo "1003,Mona Adel,IT,Analyst" >> /data/employees/employees.csv

RUN echo "ldap.server=corp-dc.internal" > /opt/hr-system/conf/application.properties && \
    echo "ldap.bindUser=hradmin" >> /opt/hr-system/conf/application.properties && \
    echo "ldap.bindPass=Welcome123" >> /opt/hr-system/conf/application.properties

RUN echo "Hiring Plan 2024" > /var/company/docs/hiring_plan.txt && \
    echo "Termination List Q3" > /var/company/docs/terminated_staff.xlsx

# ==============================
# Initial Logs
# ==============================
RUN echo "2025-01-10 Employee Service Started" > /opt/hr-system/logs/system.log && \
    echo "2025-01-11 hradmin login from 10.0.5.21" >> /opt/hr-system/logs/audit.log

# ==============================
# SSH
# ==============================
RUN mkdir /var/run/sshd && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

RUN mkdir -p /home/hradmin/.ssh && \
    echo "ssh-rsa AAAAB3NzaFakeKey hradmin@corp" > /home/hradmin/.ssh/authorized_keys && \
    chown -R hradmin:hradmin /home/hradmin/.ssh

# ==============================
# Command Logging
# ==============================
RUN echo 'export PROMPT_COMMAND='\''history -a; echo "$(date +"%F %T") | $(whoami) | $(pwd) | $(history 1)" >> /var/log/cmd.log'\''' >> /etc/bash.bashrc
RUN touch /var/log/cmd.log && chmod 666 /var/log/cmd.log

# ==============================
# Hide Container Artifact
# ==============================
RUN rm -f /.dockerenv || true

# ==============================
# Banner
# ==============================
RUN echo "Authorized access only. HR Production Server." > /etc/motd

# ==============================
# App
# ==============================
WORKDIR /opt/hr-system
COPY target/*.jar app.jar
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22
EXPOSE 8081

CMD ["/start.sh"]

