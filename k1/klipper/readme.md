Install root and fluidd
Disable the following services which are no longer required:

- mv /usr/bin/web-server /usr/bin/web-server.old
- mv /usr/bin/upgrade-server /usr/bin/upgrade-server.old
- mv /usr/bin/audio-server /usr/bin/audio-server.old
- mv /usr/bin/cx_ai_middleware /usr/bin/cx_ai_middleware.old


Edit /usr/data/nginx/nginx/nginx.conf to change the listen address for fluidd to 80 so can use default

