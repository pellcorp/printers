#!/bin/sh

# git clone --depth=1 https://github.com/pellcorp/printers.git
# wget "https://raw.githubusercontent.com/Guilouz/Creality-K1-and-K1-Max/main/Scripts/files/fixes/curl" -O install/curl
# wget "https://github.com/Guilouz/Creality-Helper-Script/blob/main/files/services/S50nginx_service" -O install/S50nginx_service
# wget "https://github.com/Guilouz/Creality-Helper-Script/blob/main/files/services/S56moonraker_service" -O install/S56moonraker_service
# wget "https://raw.githubusercontent.com/K1-Klipper/installer_script_k1_and_max/main/sensorless.cfg" -O install/sensorless.cfg
# wget "https://raw.githubusercontent.com/fluidd-core/fluidd-config/master/client.cfg" -O install/fluidd.cfg
# wget "https://raw.githubusercontent.com/K1-Klipper/installer_script_k1_and_max/main/S55klipper_service" -O install/S55klipper_service
# wget "https://github.com/Guilouz/Creality-Helper-Script/raw/main/files/moonraker/moonraker.tar.gz" -O install/moonraker.tar.gz
# wget "https://github.com/fluidd-core/fluidd/releases/latest/download/fluidd.zip" -O install/fluidd.zip
# wget "https://raw.githubusercontent.com/fluidd-core/fluidd-config/master/client.cfg" -O install/fluidd.cfg

if [ ! -f /usr/data/printer_data/config/printer.cfg ]; then
  echo "Printer data not setup"
  exit 1
fi

PWD=$(pwd)

restart_nginx() {
  /etc/init.d/S50nginx_service start
  /etc/init.d/S50nginx_service stop
}

restart_klipper() {
  /etc/init.d/S55klipper_service start
  /etc/init.d/S55klipper_service stop
}

restart_moonraker() {
  echo "Restarting moonraker..."
  /etc/init.d/S56moonraker_service stop
  /etc/init.d/S56moonraker_service start

  echo -n "Waiting for moonraker to start ..."
  while true; do
    MRK_KPY_OK=`curl localhost:7125/server/info 2> /dev/null | jq .result.klippy_connected`
    if [ "$MRK_KPY_OK" = "true" ]; then
      break;
    fi
    echo -n "."
    sleep 1
  done
  echo 
}

install_k1_klipper() {
  cd $PWD
  git clone --depth=1 https://github.com/K1-Klipper/klipper.git /usr/data/klipper
  rm -rf /usr/data/old.klipper
  ln -s /usr/data/klipper /usr/share/klipper
  # this is for bltouch
  sed -i 's/TRSYNC_TIMEOUT = 0.025/TRSYNC_TIMEOUT = 0.050/g' /usr/share/klipper/klippy/mcu.py
  /usr/share/klippy-env/bin/python3 -m compileall /usr/data/klipper/klippy
  
  cp install/printer.cfg /usr/data/printer_data/config/
  cp install/sensorless.cfg /usr/data/printer_data/config/
  cp install/fluidd.cfg /usr/data/printer_data/config/
  cp install/gcode_macros.cfg /usr/data/printer_data/config/
  cp install/S55klipper_service /etc/init.d/
  restart_klipper
}

install_moonraker() {
  cd $PWD
  echo "Installing nginx and moonraker..."
  tar -zxf install/moonraker.tar.gz -C /usr/data
  cp install/S50nginx_service /etc/init.d/
  cp install/S56moonraker_service /etc/init.d/
  cp install/notifier.conf /usr/data/printer_data/config/
  cp install/moonraker.conf /usr/data/printer_data/config/
  cp install/moonraker.secrets /usr/data/printer_data/

  echo "Updating moonraker to latest from git..."  
  cd /usr/data/moonraker/moonraker
  git stash
  git checkout master
  git pull
  cd -

  echo "Updating apprise in moonraker..."
  /usr/data/moonraker/moonraker-env/bin/python3 -m pip install --no-cache-dir --no-dependencies apprise==1.3.0 || exit $?
  sync
  
  restart_moonraker
}

install_fluid() {
  cd $PWD
  echo "Installing fluidd..."
  mkdir -p /usr/data/fluidd 
  cp install/fluidd.cfg /usr/data/printer_data/config/
  unzip -d /usr/data/fluidd install/fluidd.zip || exit $?
  sync

  restart_moonraker
  restart_nginx
}

install_guppyscreen() {
  cd $PWD
  echo "Installing guppyscreen..."
  sh -c "$(wget --no-check-certificate -qO - https://raw.githubusercontent.com/pellcorp/guppyscreen/jp_installer_moonraker_not_started/installer.sh)"
}

function remove_more_services() {
  cd $PWD
  BACKUP_DIR=/usr/data/guppyify-backup
  mv /etc/init.d/S70cx_ai_middleware $BACKUP_DIR
  mv /etc/init.d/S97webrtc $BACKUP_DIR
  mv /etc/init.d/S99mdns $BACKUP_DIR
}

install_moonraker
install_fluid
install_guppyscreen
install_k1_klipper
remove_more_services
