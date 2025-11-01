#!/usr/bin/env zsh

package_json_path=$(pwd)/package.json

(echo 'yarn install'; jq -r '.scripts | keys[]' "$package_json_path" | awk '{print "yarn " $0}')
(echo 'npm install'; jq -r '.scripts | keys[]' "$package_json_path" | awk '{print "npm run " $0}')
