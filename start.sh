#!/bin/bash
set -e

# If you prefer to start Kibana in background and nginx in foreground:
# /opt/kibana/bin/kibana &

# Start supervisord (preferred if using supervisord.conf)
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
