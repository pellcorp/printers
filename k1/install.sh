#!/bin/sh

if [ ! -f /usr/data/printer_data/config/ ]; then
  echo "Printer data not setup"
  exit 1
fi

fix_gcode_macros() {
  sed -i 's/^variable_autotune_shapers:/#&/' /usr/data/printer_data/config/gcode_macro.cfg
}

install_moonraker() {
  tar -zxvf install/moonraker.tar.gz -C /usr/data
  cp /usr/data/nginx/S50nginx /etc/init.d/
  cp /usr/data/moonraker/S56moonraker_service /etc/init.d/
  
  /usr/data/moonraker/moonraker-env/bin/python3 -m pip install --no-dependencies apprise==1.3.0
  /etc/init.d/S50nginx start
  sleep 1
  /etc/init.d/S56moonraker_service start
  sleep 1
}

install_fluid() {
  mkdir -p /usr/data/fluidd
  unzip -d /usr/data/fluidd install/fluidd.zip

  /etc/init.d/S50nginx restart
  sleep 1
  /etc/init.d/S56moonraker_service restart
  sleep 1
}

install_guppyscreen() {
  wget --no-check-certificate -qO - https://raw.githubusercontent.com/ballaswag/guppyscreen/main/installer.sh -o /tmp/installer.sh
  sh -c /tmp/installer.sh
}

fix_gcode_macros
install_moonraker
install_fluid
install_guppyscreen

