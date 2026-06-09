#!/usr/bin/env zsh

get_yarn_scripts() {
    if command -v yarn >/dev/null 2>&1; then
        echo 'yarn install'
        jq -r '.scripts // {} | keys[]' "$package_json_path" | awk '{print "yarn " $0}'
    fi
}

get_npm_scripts() {
    if command -v npm >/dev/null 2>&1; then
        echo 'npm install'
        jq -r '.scripts // {} | keys[]' "$package_json_path" | awk '{print "npm run " $0}'
    fi
}

get_all_scripts() {
    local has_package_manager=false

    if command -v yarn >/dev/null 2>&1; then
        has_package_manager=true
        get_yarn_scripts
    fi

    if command -v npm >/dev/null 2>&1; then
        has_package_manager=true
        get_npm_scripts
    fi

    [[ "$has_package_manager" == true ]]
}
