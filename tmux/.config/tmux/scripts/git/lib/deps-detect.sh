#!/usr/bin/env zsh

# Each detector handles one ecosystem; get_install_command uses the first match.
detect_node_install_command() {
    local worktree_path="$1"
    if [[ -f "$worktree_path/package.json" ]]; then
        if [[ -f "$worktree_path/pnpm-lock.yaml" ]]; then
            print -r -- 'pnpm install --frozen-lockfile'
        elif [[ -f "$worktree_path/yarn.lock" ]]; then
            local yarn_lock_header yarn_lock_version
            {
                IFS= read -r yarn_lock_header
                IFS= read -r yarn_lock_version
            } < "$worktree_path/yarn.lock" || true
            if [[ "$yarn_lock_header $yarn_lock_version" == *'# yarn lockfile v1'* ]]; then
                print -r -- 'yarn install --frozen-lockfile'
            else
                print -r -- 'yarn install --immutable'
            fi
        elif [[ -f "$worktree_path/bun.lock" || -f "$worktree_path/bun.lockb" ]]; then
            print -r -- 'bun install --frozen-lockfile'
        elif [[ -f "$worktree_path/package-lock.json" ]]; then
            print -r -- 'npm ci'
        else
            print -r -- 'npm install'
        fi
    fi
}

detect_python_install_command() {
    local worktree_path="$1"
    if [[ -f "$worktree_path/uv.lock" || -f "$worktree_path/poetry.lock" || \
        -f "$worktree_path/Pipfile.lock" || -f "$worktree_path/Pipfile" || \
        -f "$worktree_path/requirements.txt" || -f "$worktree_path/pyproject.toml" ]]; then
        if [[ -f "$worktree_path/uv.lock" ]]; then
            print -r -- 'uv sync --locked'
        elif [[ -f "$worktree_path/poetry.lock" ]]; then
            print -r -- 'poetry install'
        elif [[ -f "$worktree_path/Pipfile.lock" ]]; then
            print -r -- 'pipenv sync'
        elif [[ -f "$worktree_path/Pipfile" ]]; then
            print -r -- 'pipenv install'
        elif [[ -f "$worktree_path/requirements.txt" ]]; then
            print -r -- 'python3 -m venv .venv && .venv/bin/python -m pip install -r requirements.txt'
        else
            print -r -- 'uv sync'
        fi
    fi
}

detect_rust_install_command() {
    local worktree_path="$1"
    if [[ -f "$worktree_path/Cargo.toml" ]]; then
        if [[ -f "$worktree_path/Cargo.lock" ]]; then
            print -r -- 'cargo fetch --locked'
        else
            print -r -- 'cargo fetch'
        fi
    fi
}

detect_go_install_command() {
    local worktree_path="$1"
    if [[ -f "$worktree_path/go.mod" ]]; then
        print -r -- 'go mod download'
    fi
}

detect_cpp_install_command() {
    local worktree_path="$1"
    if [[ -f "$worktree_path/vcpkg.json" ]]; then
        print -r -- 'vcpkg install'
        return
    elif [[ -f "$worktree_path/conanfile.py" || -f "$worktree_path/conanfile.txt" ]]; then
        print -r -- 'conan install . --build=missing'
    fi
}

detect_java_install_command() {
    local worktree_path="$1"
    if [[ -f "$worktree_path/pom.xml" ]]; then
        if [[ -f "$worktree_path/mvnw" ]]; then
            print -r -- './mvnw -B dependency:go-offline'
        else
            print -r -- 'mvn -B dependency:go-offline'
        fi
    elif [[ -f "$worktree_path/gradlew" && ( -f "$worktree_path/build.gradle" || -f "$worktree_path/build.gradle.kts" ) ]]; then
        print -r -- './gradlew dependencies'
    elif [[ -f "$worktree_path/build.gradle" || -f "$worktree_path/build.gradle.kts" ]]; then
        print -r -- 'gradle dependencies'
    fi
}

# Return the install command for the first recognized ecosystem in a worktree.
get_install_command() {
    local worktree_path="$1"
    local detector install_command

    for detector in \
        detect_node_install_command \
        detect_python_install_command \
        detect_rust_install_command \
        detect_go_install_command \
        detect_cpp_install_command \
        detect_java_install_command; do
        install_command=$("$detector" "$worktree_path")
        if [[ -n "$install_command" ]]; then
            print -r -- "$install_command"
            return
        fi
    done
}
