#!/bin/sh

# git clone --depth=1 https://github.com/pellcorp/printers.git
# wget "https://raw.githubusercontent.com/Guilouz/Creality-K1-and-K1-Max/main/Scripts/files/fixes/curl" -O install/curl

if [ ! -f /usr/data/printer_data/config/printer.cfg ]; then
  echo "Printer data not setup"
  exit 1
fi

fix_gcode_macros() {
  echo "Fixing some gcode config ..."
  sed -i 's/^variable_autotune_shapers:/#&/' /usr/data/printer_data/config/gcode_macro.cfg
}

install_moonraker() {
  echo "Installing nginx and moonraker..."
  install/curl -L "https://raw.githubusercontent.com/Guilouz/Creality-K1-and-K1-Max/main/Scripts/files/moonraker/moonraker.tar.gz" -o /usr/data/moonraker.tar.gz
  if [ $? -ne 0 ]; then
    echo "Failed to download moonraker.tar.gz"
    exit 1
  fi
  tar -zxf /usr/data/moonraker.tar.gz -C /usr/data
  cp /usr/data/nginx/S50nginx /etc/init.d/
  cp /usr/data/moonraker/S56moonraker_service /etc/init.d/
  cp install/notifier.conf /usr/data/printer_data/config/
  cp install/moonraker.conf /usr/data/printer_data/config/
  cp install/moonraker.secrets /usr/data/printer_data/
  
  echo "Updating apprise in moonraker..."
  /usr/data/moonraker/moonraker-env/bin/python3 -m pip install --no-cache-dir --no-dependencies apprise==1.3.0
  sync
  
  echo "Starting nginx and moonraker..."
  /etc/init.d/S50nginx start
  
  /etc/init.d/S56moonraker_service start
  
  echo "Waiting for moonraker to start ..."
  while true; do
    MRK_KPY_OK=`curl localhost:7125/server/info | jq .result.klippy_connected`
    if [ "$MRK_KPY_OK" = "true" ]; then
      break;
    fi
    sleep 1
  done
}

install_fluid() {
  echo "Installing fluidd..."
  install/curl -L "https://github.com/fluidd-core/fluidd/releases/latest/download/fluidd.zip" -o /usr/data/fluidd.zip
  if [ $? -ne 0 ]; then
    echo "Failed to download fluidd.zip"
    exit 1
  fi
  mkdir -p /usr/data/fluidd
  unzip -d /usr/data/fluidd /usr/data/fluidd.zip
  rm /usr/data/fluidd.zip
  sync
  
  /etc/init.d/S50nginx restart
  sleep 1
  /etc/init.d/S56moonraker_service restart
  sleep 1
}

install_guppyscreen() {
  echo "Installing guppyscreen..."
  sh -c "GS_RESTART_KLIPPER=y GS_DECREALITY=y $(wget --no-check-certificate -qO - https://raw.githubusercontent.com/pellcorp/guppyscreen/jp_configure_confirm_install/installer.sh)"
}

fix_gcode_macros
install_moonraker
install_fluid
install_guppyscreen

