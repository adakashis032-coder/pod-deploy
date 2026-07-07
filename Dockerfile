FROM ubuntu:22.04

ARG KIBANA_VERSION=8.15.0
ENV KIBANA_HOME=/opt/kibana
ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites, nginx, supervisor
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl gnupg lsb-release nginx supervisor tar && \
    rm -rf /var/lib/apt/lists/*

# Download and extract Kibana
RUN mkdir -p ${KIBANA_HOME} && \
    curl -fsSL "https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz" -o /tmp/kibana.tar.gz && \
    tar -xzf /tmp/kibana.tar.gz -C /opt && \
    mv /opt/kibana-${KIBANA_VERSION}-linux-x86_64 ${KIBANA_HOME} && \
    rm /tmp/kibana.tar.gz

# Copy configs (make sure these files exist in your build context!)
COPY kibana.yml ${KIBANA_HOME}/config/kibana.yml
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Expose nginx port
EXPOSE 80

# Use supervisord to manage processes
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
