# Introduction

THIS IS FOR REFERENCE ONLY, THERE IS A VERY REAL POSIBILITY OF BRICKING YOUR PRINTER!!!!!

# Installation

```
git config --global http.sslVerify false
git clone https://github.com/pellcorp/printers.git /usr/data/printers
cd /usr/data/printers/k1
./install.sh
```

## Resources

The following install files were originally from other projects, modified locally.  The reason why I have saved them to the
repository instead of downloading them is I can ensure my K1 is restored to the same state, as I have control of all the files,
I don't wan't to inadvertantly pick up another version of a file which might be incompatible with something else.

- install/S50nginx_service -> https://github.com/Guilouz/Creality-Helper-Script/blob/main/files/services/S50nginx_service
- install/S56moonraker_service -> https://github.com/Guilouz/Creality-Helper-Script/blob/main/files/services/S56moonraker_service
- install/moonraker.conf -> https://github.com/Guilouz/Creality-Helper-Script/blob/main/files/moonraker/moonraker.conf
- install/sensorless.cfg -> https://raw.githubusercontent.com/K1-Klipper/installer_script_k1_and_max/main/sensorless.cfg
- install/S55klipper_service -> https://raw.githubusercontent.com/K1-Klipper/installer_script_k1_and_max/main/S55klipper_service
- install/fluidd-v1.29.1.zip -> https://github.com/fluidd-core/fluidd/releases/download/v1.29.1/fluidd.zip
- install/fluidd.cfg -> https://raw.githubusercontent.com/fluidd-core/fluidd-config/master/client.cfg
- install/guppyscreen.tar.gz -> https://github.com/ballaswag/guppyscreen/releases/download/0.0.24-beta/guppyscreen.tar.gz
- install/curl -> https://raw.githubusercontent.com/ballaswag/k1-discovery/main/bin/curl

### Moonraker

I use my fork of moonraker, to make sure I always get the same version

### Nginx

In an attempt to simplify the installation of moonraker, I have taken the moonraker.tar.gz and extracted the nginx directory.   
I have been unable to determine where to get nginx for mips.

The nginx binaries originally came from:
https://github.com/CrealityOfficial/K1_Series_Annex/blob/main/fluidd/fluidd/fluidd.tar

Use the `recreate-nginx.sh` script to extract the nginx directory from:
https://github.com/Guilouz/Creality-Helper-Script/raw/main/files/moonraker/moonraker.tar.gz

The install/nginx.conf is originally from moonraker.tar.gz:nginx/nginx/nginx.conf, but I modified it locally to already
listen on port 80.

### Moonraker Env

The moonraker-env originally came from:
https://github.com/CrealityOfficial/K1_Series_Annex/blob/main/fluidd/fluidd/fluidd.tar

Use the `recreate-moonraker-env.sh` script to extract the moonraker/moonraker-env directory from:
https://github.com/Guilouz/Creality-Helper-Script/raw/main/files/moonraker/moonraker.tar.gz

I do install the asyncio and updated apprise packages locally to avoid doing that at installation time.

## Klipper

I use my fork of the k1-klipper repo to make sure I always get the same version

### Creality OS Specific

K1 Creality OS assumes klipper is located /usr/share, so we soft link /usr/data/klipper to /usr/share/klipper
The /usr/share/klippy-env is provided by the Creality Firmware, Klipper has not updated the python requirements 
for klipper with anything of consequence for some time, so we continue to use /usr/share/klipper-env as is.

## Documentation

The following wiki pages are my attempt to document the installation process and the various steps I am automating with my install script, both
pages are works in progress.

- https://github.com/pellcorp/creality/wiki/K1-Bltouch
- https://github.com/pellcorp/creality/wiki/K1-Minimal-Creality
