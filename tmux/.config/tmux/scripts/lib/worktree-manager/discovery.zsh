#!/usr/bin/env zsh

# stdout contains six NUL-delimited fields per row; errors go to stderr.
# Branch inventory: four NUL fields per row: full ref, local/remote,
# display name, occupied_by canonical path (empty when available).
list_repository_branches() {
    emulate -L zsh
    local repo_root="${1:A}" scratch field ref kind name symbolic
    local -a records
    local -A occupied
    _worktree_manager_is_root "$repo_root" || return 1
    scratch=$(mktemp -d "${TMPDIR:-/tmp}/worktree-branches.XXXXXXXX") || return 1
    {
        git -C "$repo_root" worktree list --porcelain -z > "$scratch/worktrees" || return 1
        parse_worktree_porcelain "$repo_root" "$scratch/worktrees" > "$scratch/normalized" || return 1
        while IFS= read -r -d '' field; do records+=("$field"); done < "$scratch/normalized"
        local i
        for ((i=1; i<=${#records}; i+=6)); do
            [[ -n "${records[i+4]}" ]] || continue
            occupied[refs/heads/${records[i+4]}]="${records[i+3]:A}"
        done
        git -C "$repo_root" for-each-ref --format='%(refname)%00%(symref)%00' \
            refs/heads refs/remotes > "$scratch/refs" || return 1
        # for-each-ref inserts a newline after each formatted record.
        while IFS= read -r -d '' ref && IFS= read -r -d '' symbolic; do
            ref="${ref#$'\n'}"
            [[ -n "$symbolic" ]] && continue
            case "$ref" in
                refs/heads/*) kind=local; name="${ref#refs/heads/}" ;;
                refs/remotes/*) kind=remote; name="${ref#refs/remotes/}" ;;
                *) continue ;;
            esac
            printf '%s\0' "$ref" "$kind" "$name" "${occupied[$ref]:-}"
        done < "$scratch/refs"
    } always {
        rm -rf -- "$scratch"
    }
}

_worktree_manager_is_root() {
    emulate -L zsh
    local worktree_path="$1" top_level
    top_level=$(git -C "$worktree_path" rev-parse --show-toplevel 2>/dev/null) || return 1
    [[ "${top_level:A}" == "${worktree_path:A}" ]]
}

worktree_status() {
    emulate -L zsh
    local worktree_path="$1" output
    if [[ ! -d "$worktree_path" ]]; then
        print -r -- missing
    elif ! _worktree_manager_is_root "$worktree_path"; then
        print -r -- unknown
    elif output=$(git -C "$worktree_path" status --porcelain --untracked-files=normal 2>/dev/null); then
        if [[ -n "$output" ]]; then
            print -r -- dirty
        else
            print -r -- clean
        fi
    else
        print -r -- unknown
    fi
}

_worktree_manager_emit_record() {
    emulate -L zsh
    local repo_root="$1" worktree_path="$2" branch="$3" head="$4"
    local detached="$5" bare="$6" locked="$7" prunable="$8" malformed="$9"
    local repo_group="${10}" repo_name="${11}" common_dir="${12}" git_dir
    local -a flags
    if [[ "$malformed" == 1 || -z "$worktree_path" ||
        ( "$bare" != 1 && ( -z "$head" || ( -z "$branch" && "$detached" != 1 ) ) ) ||
        ( "$detached" == 1 && -n "$branch" ) ||
        ( "$bare" == 1 && ( -n "$branch" || "$detached" == 1 ) ) ]]; then
        print -u2 -r -- "worktree-manager: $repo_root: malformed worktree record skipped"
        return 0
    fi
    # Git may report the storage directory as the main registration for a
    # separate-git-dir checkout. Reconcile only against a verified owner root.
    if [[ "$bare" != 1 && -n "$common_dir" && "${worktree_path:A}" == "$common_dir" ]] &&
        _worktree_manager_is_root "$repo_root" &&
        git_dir=$(git -C "$repo_root" rev-parse --absolute-git-dir 2>/dev/null) &&
        [[ "${git_dir:A}" == "$common_dir" ]]; then
        worktree_path="$repo_root"
    fi
    if [[ -n "$common_dir" ]] && _worktree_manager_is_root "$worktree_path" &&
        git_dir=$(git -C "$worktree_path" rev-parse --absolute-git-dir 2>/dev/null); then
        [[ "${git_dir:A}" == "$common_dir" ]] && flags+=(main)
    fi
    [[ "$detached" == 1 ]] && flags+=(detached)
    [[ "$locked" == 1 ]] && flags+=(locked)
    [[ "$prunable" == 1 ]] && flags+=(prunable)
    [[ "$bare" == 1 ]] && flags+=(bare)
    printf '%s\0' "$repo_root" "$repo_group" "$repo_name" "$worktree_path" \
        "$branch" "${(j:,:)flags}"
}

parse_worktree_porcelain() {
    emulate -L zsh
    local repo_root="$1" porcelain_file="$2" token
    local worktree_path='' branch='' head='' detached=0 bare=0 locked=0 prunable=0 malformed=0 active=0
    local common_dir='' repo_name="${repo_root:t}" repo_group="${repo_root:h:t}" relative
    if [[ ! -r "$porcelain_file" ]]; then
        print -u2 -r -- "worktree-manager: $repo_root: cannot read porcelain file"
        return 0
    fi
    common_dir=$(git -C "$repo_root" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || common_dir=''
    [[ -n "$common_dir" ]] && common_dir="${common_dir:A}"
    # discover_worktrees supplies the root through zsh's dynamic local scope.
    if [[ -n "${wm_projects_root:-}" && "$repo_root" == "$wm_projects_root"/* ]]; then
        relative="${repo_root#"$wm_projects_root"/}"
        if [[ "$relative" == */* ]]; then
            repo_group="${relative%%/*}"
        else
            repo_group=''
        fi
    fi
    while IFS= read -r -d '' token; do
        if [[ -z "$token" ]]; then
            if (( active )); then
                _worktree_manager_emit_record "$repo_root" "$worktree_path" "$branch" "$head" \
                    "$detached" "$bare" "$locked" "$prunable" "$malformed" "$repo_group" "$repo_name" "$common_dir"
            fi
            worktree_path='' branch='' head='' detached=0 bare=0 locked=0 prunable=0 malformed=0 active=0
            continue
        fi
        active=1
        case "$token" in
            'worktree '*)
                [[ -n "$worktree_path" ]] && malformed=1
                worktree_path="${token#worktree }"
                [[ "$worktree_path" == /* ]] || malformed=1 ;;
            'HEAD '*) [[ -n "$head" ]] && malformed=1; head="${token#HEAD }" ;;
            'branch refs/heads/'*) [[ -n "$branch" ]] && malformed=1; branch="${token#branch refs/heads/}" ;;
            detached) detached=1 ;;
            bare) bare=1 ;;
            locked|'locked '*) locked=1 ;;
            prunable|'prunable '*) prunable=1 ;;
            *) malformed=1 ;;
        esac
    done < "$porcelain_file"
    if (( active )) || [[ -n "$token" ]]; then
        print -u2 -r -- "worktree-manager: $repo_root: incomplete worktree record skipped"
    fi
    return 0
}

# Resolve one candidate to its common git dir. Emits a NUL triple
# (common_dir, candidate, owner-flag) for the parent to collect. Runs in a
# forked subshell; failures emit nothing (a non-root candidate warns on stderr).
_worktree_manager_resolve_candidate() {
    emulate -L zsh
    local candidate="$1" common_dir git_dir owner=0
    common_dir=$(git -C "$candidate" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || return 0
    common_dir="${common_dir:A}"
    if ! _worktree_manager_is_root "$candidate"; then
        print -u2 -r -- "worktree-manager: $candidate: candidate is not a worktree root"
        return 0
    fi
    if git_dir=$(git -C "$candidate" rev-parse --absolute-git-dir 2>/dev/null) &&
        [[ "${git_dir:A}" == "$common_dir" ]]; then
        owner=1
    fi
    printf '%s\0%s\0%s\0' "$common_dir" "$candidate" "$owner"
}

# Emit the worktree records for one repository. $1 common dir, $2 candidate for
# `git -C`, $3 owning root (empty to resolve), $4 scratch dir. Writes the final
# six-field records to stdout; runs in a forked subshell.
_worktree_manager_emit_repo_worktrees() {
    emulate -L zsh
    local common_dir="$1" candidate="$2" owner="$3" scratch="$4"
    local repo_root="${owner:-$candidate}" entry git_dir porcelain
    porcelain=$(mktemp "$scratch/porcelain.XXXXXXXX") || return 0
    if ! git -C "$candidate" worktree list --porcelain -z > "$porcelain" 2>/dev/null; then
        print -u2 -r -- "worktree-manager: $repo_root: cannot list worktrees"
        rm -f -- "$porcelain"
        return 0
    fi
    if [[ -z "$owner" ]]; then
        # The main root may be outside the scan; use registered paths and Git
        # identity, with no common-directory naming assumption.
        while IFS= read -r -d '' entry; do
            [[ "$entry" == 'worktree '* ]] || continue
            entry="${entry#worktree }"
            if _worktree_manager_is_root "$entry" &&
                git_dir=$(git -C "$entry" rev-parse --absolute-git-dir 2>/dev/null) &&
                [[ "${git_dir:A}" == "$common_dir" ]]; then
                repo_root="${entry:A}"
                break
            fi
        done < "$porcelain"
    fi
    parse_worktree_porcelain "$repo_root" "$porcelain"
    rm -f -- "$porcelain"
}

discover_worktrees() {
    emulate -L zsh
    local wm_projects_root="${1:A}" candidate entry common_dir scratch owner job
    local -A candidate_by_common owner_by_common
    local -a common_dirs resolve_jobs emit_jobs
    local max_jobs="${WM_JOBS:-8}"
    if [[ ! -d "$wm_projects_root" ]]; then
        print -u2 -r -- "worktree-manager: $wm_projects_root: projects root is missing"
        return 0
    fi
    scratch=$(mktemp -d "${TMPDIR:-/tmp}/worktree-manager.XXXXXXXX") || return 1
    {
        if command -v fd >/dev/null 2>&1; then
            # fd is far faster than find here (~0.5s vs ~8s) and prunes matched
            # .git entries. --no-ignore keeps repos outside ignore rules; the
            # --exclude list mirrors the find prune set in the fallback below.
            fd --hidden --no-ignore --type directory --type file --glob --prune \
                --exclude node_modules --exclude .cache --exclude .venv --exclude venv \
                --exclude vendor --exclude dist --exclude build --exclude target \
                '.git' "$wm_projects_root" -0 \
                > "$scratch/candidates" 2> "$scratch/find-errors" || true
        else
            find "$wm_projects_root" \
                \( -type d \( -name node_modules -o -name .cache -o -name .venv -o -name venv \
                    -o -name vendor -o -name dist -o -name build -o -name target \) -prune \) -o \
                \( -name .git \( -type d -o -type f \) -print0 -prune \) \
                > "$scratch/candidates" 2> "$scratch/find-errors" || true
        fi
        if [[ -s "$scratch/find-errors" ]]; then
            print -u2 -r -- "worktree-manager: $wm_projects_root: repository traversal errors"
            cat "$scratch/find-errors" >&2
        fi
        # Phase 2: resolve candidates in parallel. Output is an internal NUL
        # stream of (common_dir, candidate, owner) triples, kept separate from
        # the final records on stdout.
        {
            while IFS= read -r -d '' entry; do
                candidate="${${entry%/}:h}"
                _worktree_manager_resolve_candidate "$candidate" &
                resolve_jobs+=($!)
                if (( ${#resolve_jobs} >= max_jobs )); then
                    wait $resolve_jobs[1]
                    resolve_jobs=(${resolve_jobs[2,-1]})
                fi
            done < "$scratch/candidates"
            for job in "${resolve_jobs[@]}"; do wait "$job"; done
        } > "$scratch/resolved"
        # Resolve all candidates before emitting any registry: a later main
        # candidate supplies ownership even when its common directory is custom.
        while IFS= read -r -d '' common_dir; do
            IFS= read -r -d '' candidate
            IFS= read -r -d '' owner
            if [[ -z "${candidate_by_common[$common_dir]:-}" ]]; then
                candidate_by_common[$common_dir]="$candidate"
                common_dirs+=("$common_dir")
            fi
            [[ "$owner" == 1 ]] && owner_by_common[$common_dir]="$candidate"
        done < "$scratch/resolved"
        # Phase 3: emit each repository's records in parallel. Output order is
        # nondeterministic; the picker sorts rows before display.
        for common_dir in "${common_dirs[@]}"; do
            _worktree_manager_emit_repo_worktrees "$common_dir" \
                "${candidate_by_common[$common_dir]}" "${owner_by_common[$common_dir]:-}" "$scratch" &
            emit_jobs+=($!)
            if (( ${#emit_jobs} >= max_jobs )); then
                wait $emit_jobs[1]
                emit_jobs=(${emit_jobs[2,-1]})
            fi
        done
        for job in "${emit_jobs[@]}"; do wait "$job"; done
    } always {
        rm -rf -- "$scratch"
    }
    return 0
}
