#!/bin/sh

/usr/bin/mcu_reset.sh
/sbin/reboot -f
/bin/rm -rf /usr/data/macaddr.txt
/bin/rm -rf /usr/data/wpa_supplicant.conf
/bin/rm -rf /usr/data/ai_image
/bin/rm -rf /usr/data/timelapse
/bin/rm -rf '/usr/data/lost+found'
/bin/rm -rf /overlay/upper/*
/bin/sync
/etc/init.d/rcK
ACTION=stop /usr/bin/auto_uvc.sh
/sbin/swapoff -a
/usr/bin/find /usr/data/ -path '/usr/data/creality' -prune -o -path '/usr/data/machine_production_info' -prune -o -path '/usr/data/' -o -print -exec rm -rf {} \;

