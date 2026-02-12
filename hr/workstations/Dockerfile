FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Africa/Cairo

# ==============================
# System tools (workstation-like)
# ==============================
RUN apt-get update && apt-get install -y \
    bash \
    curl wget \
    iproute2 \
    vim nano less \
    net-tools iputils-ping traceroute \
    procps htop \
    samba \
    cups \
    netcat-openbsd \
    tcpdump \
    nmap \
    rsyslog cron \
    util-linux \
    openssh-server \
    ca-certificates \
    dnsutils \
    && rm -rf /var/lib/apt/lists/*

# ==============================
# Copy startup logic
# ==============================
COPY start.sh /start.sh
RUN chmod +x /start.sh

# ==============================
# IMPORTANT: force startup logic
# ==============================
ENTRYPOINT ["/start.sh"]

