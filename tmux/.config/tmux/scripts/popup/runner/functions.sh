#!/usr/bin/env zsh

get_yarn_scripts() {
    (echo 'yarn install'; jq -r '.scripts | keys[]' "$package_json_path" | awk '{print "yarn " $0}')
}

get_npm_scripts() {
    (echo 'npm install'; jq -r '.scripts | keys[]' "$package_json_path" | awk '{print "npm run " $0}')
}

get_all_scripts() {
    (echo 'yarn install'; jq -r '.scripts | keys[]' "$package_json_path" | awk '{print "yarn " $0}')
    (echo 'npm install'; jq -r '.scripts | keys[]' "$package_json_path" | awk '{print "npm run " $0}')
}
