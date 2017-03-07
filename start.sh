#!/bin/sh
set -e -x

su -c "python3 /src/manage.py migrate" hc

uwsgi --master \
    --uid hc \
    --gid hc \
    --http-socket :9090 \
    --processes 2 \
    --threads 2 \
    --chdir /src \
    --plugin python3 \
    --module hc.wsgi:application \
    --enable-threads \
    --thunder-lock \
    --static-map /static=/src/static-collected \
    --attach-daemon "python3 manage.py sendalerts"
