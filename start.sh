#!/bin/bash
set -e

# start kibana in background if you prefer not to use supervisord
# /opt/kibana/bin/kibana &

# start nginx in foreground
nginx -g "daemon off;"
