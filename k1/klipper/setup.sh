#!/bin/sh

mv /usr/bin/web-server /usr/bin/web-server.old
mv /usr/bin/upgrade-server /usr/bin/upgrade-server.old
mv /usr/bin/audio-server /usr/bin/audio-server.old
mv /usr/bin/cx_ai_middleware /usr/bin/cx_ai_middleware.old

kill -9 $(ps -ef | grep web-server | grep -v "grep" | awk '{print $1}')
kill -9 $(ps -ef | grep upgrade-server | grep -v "grep" | awk '{print $1}')
kill -9 $(ps -ef | grep audio-server | grep -v "grep" | awk '{print $1}')
kill -9 $(ps -ef | grep cx_ai_middleware | grep -v "grep" | awk '{print $1}')

sed -i 's/4408/80/g' /usr/data/nginx/nginx/nginx.conf
/etc/init.d/S50nginx restart
/usr/data/moonraker/moonraker-env/bin/python3 -m pip install --no-dependencies apprise==1.3.0

