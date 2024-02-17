#!/bin/sh

#
# I borrowed a lot of ideas from https://github.com/lokiagent/klipper-backup and 
# https://github.com/Staubgeborener/klipper-backup but just make it simpler
#

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

cd $backup_repo_path
if [ ! -d ".git" ]; then
    >&2 echo "This does not appear to be a backup repo -- aborting"
    exit 1
fi

# don't clobber the default git config for author just pass the --author arg to each commit
author_arg=""
if [ -n "$commit_username" ] && [ -n "$commit_email" ]; then
    author_arg="--author \"$commit_username <$commit_email>\""
fi

# we assume we git cloned the repo anonymously initially, now we need to add the token
base_repository=$(git remote get-url origin | sed 's/https:\/\/.*@github.com\///' | sed 's/\.git$//' | sed 's/git@//g')
github_username=$(echo $base_repository | awk -F '/' '{print $1}')
github_repository=$(echo $base_repository | awk -F '/' '{print $2}')

# update the repo to include the token
git remote set-url origin https://"$github_token"@github.com/"$github_username"/"$github_repository".git

git config advice.skippedCherryPicks false
git config http.sslVerify false

remote_branch=$(git rev-parse --abbrev-ref @{u} | awk -F '/' '{print $2}')

# because the same repo is used on multiple printers, and we might actually be committing adhoc for stuff like slicers
# we want to clean the current repo pull latest and force our local repo to be equal with latest remote
git reset --hard
git clean -f -d
git fetch origin
git reset --hard origin/$remote_branch

if [ -n "$target_directory" ]; then
    mkdir -p $target_directory
fi

while read file; do
    if [ -f "$file" ]; then
        file=$(echo $file | sed 's:^./::g')
        directory=$(dirname "$file")
        file=$(basename "$file")
        # Check if file is an extra backup of printer.cfg moonraker/klipper seems to like to make 4-5 of these sometimes no need to back them all up as well.
        if [[ $file =~ ^printer-[0-9]+_[0-9]+\.cfg$ ]]; then
            echo "Skipping file: $file"
        else
            mkdir -p "$target_directory/$backup_path/$directory"
            cp -v "$directory/$file" "$target_directory/$backup_path/$directory"
        fi
    else
        echo "Skipping: $file"
    fi
done < <(cd $klipper_config && find . -type f -print 0)

git add .
git commit -m "New backup from $(date +"%d-%m-%y")" $author_arg

if [ "$1" != "-o" ]; then
    git push -u origin
fi
