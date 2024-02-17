#!/bin/sh

backup_repo_path=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if [ -f "$backup_repo_path"/.env ]; then
    source "$backup_repo_path"/.env
else
    >&2 echo "$backup_repo_path/.env file missing -- aborting"
    exit 1
fi

if [ -z "$klipper_config" ]; then
    >&2 echo "Missing klipper configuration -- aborting"
    exit 1
elif [ ! -d "$klipper_config" ]; then
    >&2 echo "Klipper $klipper_config directory not found -- aborting"
    exit 1
fi

cp $backup_repo_path/backup_macro.sh $klipper_config/
sed -i "s/%backup_repo_path%/$backup_repo_path/g" $klipper_config/backup_macro.sh
if grep -q "include backup_macro.cfg" $K1_CONFIG_DIR/printer.cfg ; then
    echo "printer.cfg already includes backup macro"
else
    sed -i '12 i \[include backup_macro.cfg\]' $klipper_config/printer.cfg
    echo "IMPORTANT: Restart klipper after this"
fi

