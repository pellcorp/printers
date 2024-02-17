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
  rm /usr/data/fluidd.zip
  cp /usr/data/nginx/S50nginx /etc/init.d/
  cp /usr/data/moonraker/S56moonraker_service /etc/init.d/
  
  /usr/data/moonraker/moonraker-env/bin/python3 -m pip install --no-dependencies apprise==1.3.0
  /etc/init.d/S50nginx start
  sleep 1
  /etc/init.d/S56moonraker_service start
  sleep 1
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
  
  /etc/init.d/S50nginx restart
  sleep 1
  /etc/init.d/S56moonraker_service restart
  sleep 1
}

install_guppyscreen() {
  echo "Installing guppyscreen..."
  sh -c "GUPPYSCREEN_CONFIRM_PROMPTS=n $(wget --no-check-certificate -qO - https://raw.githubusercontent.com/pellcorp/guppyscreen/jp_noconfirm_install/installer.sh)"
}

fix_gcode_macros
install_moonraker
install_fluid
install_guppyscreen

