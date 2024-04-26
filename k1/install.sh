#!/bin/sh

if [ ! -f /usr/data/printer_data/config/printer.cfg ]; then
  >&2 echo "ERROR: Printer data not setup"
  exit 1
fi

# https://stackoverflow.com/a/1638397
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

if [ "$SCRIPTPATH" != "/usr/data/printers/k1" ]; then
  >&2 echo "ERROR: This git repo must be cloned to /usr/data/printers"
fi

install_moonraker() {
  cd $PWD
  echo "Installing nginx and moonraker..."
  git clone https://github.com/pellcorp/moonraker.git /usr/data/moonraker || exit $?
  tar -zxf install/nginx.tar.gz -C /usr/data/ || exit $?
  
  cp install/nginx.conf /usr/data/nginx/nginx/
  cp install/S50nginx_service /etc/init.d/
  cp install/S56moonraker_service /etc/init.d/
  cp install/notifier.conf /usr/data/printer_data/config/
  cp install/moonraker.conf /usr/data/printer_data/config/
  cp install/moonraker.secrets /usr/data/printer_data/

  echo "Installing moonraker-env ..."
  tar -zxf install/moonraker-env.tar.gz -C /usr/data/ || exit $?
  sync
}

install_fluid() {
  cd $PWD
  echo "Installing fluidd..."
  mkdir -p /usr/data/fluidd 
  cp install/fluidd.cfg /usr/data/printer_data/config/
  unzip -qd /usr/data/fluidd install/fluidd-v1.29.1.zip || exit $?
  sync
}

install_klipper() {
  echo "Installing k1 klipper..."
  git clone https://github.com/pellcorp/k1-klipper.git /usr/data/klipper || exit $?
  rm -rf /usr/share/klipper
  ln -s /usr/data/klipper /usr/share/
  
  # make sure we started more limited klipper service
  cp install/S55klipper_service /etc/init.d/

  /usr/share/klippy-env/bin/python3 -m compileall /usr/data/klipper/klippy

  # updated creality free config
  cp install/printer.cfg /usr/data/printer_data/config/
  cp install/sensorless.cfg /usr/data/printer_data/config/
  cp install/fluidd.cfg /usr/data/printer_data/config/
  cp install/gcode_macro.cfg /usr/data/printer_data/config/
  
  # remove some unwanted additional config
  rm /usr/data/printer_data/config/printer_params.cfg
  rm /usr/data/printer_data/config/factory_printer.cfg
  sync
}

install_guppyscreen() {
  cd $PWD
  echo "Installing guppyscreen..."

  BACKUP_DIR=/usr/data/guppyify-backup
  K1_GUPPY_DIR=/usr/data/guppyscreen
  FT2FONT_PATH=/usr/lib/python3.8/site-packages/matplotlib/ft2font.cpython-38-mipsel-linux-gnu.so
  KLIPPER_PATH=/usr/share/klipper
  KLIPPY_EXTRA_DIR=$KLIPPER_PATH/klippy/extras
  GCODE_SHELL_CMD=$KLIPPY_EXTRA_DIR/gcode_shell_command.py
  SHAPER_CONFIG=$KLIPPY_EXTRA_DIR/calibrate_shaper_config.py
  K1_CONFIG_DIR=/usr/data/printer_data/config

  tar -zxf install/guppyscreen.tar.gz -C /usr/data/

  # lets make sure that ssh gets started upon reboot
  mkdir -p $BACKUP_DIR
  cp /etc/init.d/S50dropbear $BACKUP_DIR
  cp $K1_GUPPY_DIR/k1_mods/S50dropbear /etc/init.d/S50dropbear

  mv /etc/init.d/S12boot_display $BACKUP_DIR
  mv /etc/init.d/S99start_app $BACKUP_DIR
  # these are extras that guppy install does not normally remove
  mv /etc/init.d/S70cx_ai_middleware $BACKUP_DIR
  mv /etc/init.d/S97webrtc $BACKUP_DIR
  mv /etc/init.d/S99mdns $BACKUP_DIR
  mv /usr/lib/python3.8/site-packages/matplotlib/ft2font.cpython-38-mipsel-linux-gnu.so $BACKUP_DIR
  
  cp $K1_GUPPY_DIR/k1_mods/gcode_shell_command.py $GCODE_SHELL_CMD
  cp $K1_GUPPY_DIR/k1_mods/calibrate_shaper_config.py $SHAPER_CONFIG

  mkdir -p $K1_CONFIG_DIR/GuppyScreen/scripts
  cp $K1_GUPPY_DIR/scripts/*.cfg $K1_CONFIG_DIR/GuppyScreen
  cp $K1_GUPPY_DIR/scripts/*.py $K1_CONFIG_DIR/GuppyScreen/scripts

  cp $K1_GUPPY_DIR/k1_mods/S99guppyscreen /etc/init.d/S99guppyscreen
  
  ln -sf $K1_GUPPY_DIR/k1_mods/guppy_module_loader.py $KLIPPY_EXTRA_DIR/guppy_module_loader.py
  ln -sf $K1_GUPPY_DIR/k1_mods/guppy_config_helper.py $KLIPPY_EXTRA_DIR/guppy_config_helper.py
  ln -sf $K1_GUPPY_DIR/k1_mods/tmcstatus.py $KLIPPY_EXTRA_DIR/tmcstatus.py

  cp $K1_GUPPY_DIR/k1_mods/ft2font.cpython-38-mipsel-linux-gnu.so $FT2FONT_PATH
  ln -sf $K1_GUPPY_DIR/k1_mods/respawn/libeinfo.so.1 /lib/libeinfo.so.1
  ln -sf $K1_GUPPY_DIR/k1_mods/respawn/librc.so.1 /lib/librc.so.1

  sync

  if ! diff $K1_GUPPY_DIR/k1_mods/S50dropbear /etc/init.d/S50dropbear > /dev/null ; then
    >&2 echo "ERROR: Dropbear (SSHD) didn't install properly."
    exit 1
  fi
}

install_moonraker
install_fluid
install_klipper
install_guppyscreen

echo "IMPORTANT: You must powercycle the printer so that the nozzle firmware is updated"
