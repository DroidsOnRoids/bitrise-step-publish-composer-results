#!/bin/bash
set -e

cd $(mktemp -d)
git init
git remote add origin "$remote_url"
git pull origin master
mkdir -p docs
rm -rf "docs/$BITRISE_APP_TITLE"

set +e
composer_html_dir_name=$(find "$BITRISE_SOURCE_DIR" -path \*/composer/\*index.html | xargs dirname)
if [ -z "$composer_html_dir_name" ]; then
      echo -n "irrelevant" | envman add --key STF_DEVICE_COUNT
      exit 1
fi
set -e
composer_dir_name=$(realpath "${composer_html_dir_name}/..")

jq -n "$STF_DEVICE_SERIAL_LIST | length" | envman add --key STF_DEVICE_COUNT

mv ${composer_dir_name} "docs/$BITRISE_APP_TITLE"
git add -A
git commit -am "$BITRISE_APP_TITLE $BITRISE_BUILD_NUMBER"
git push origin master
