#!/usr/bin/env bats

setup() {
    test_root="$(mktemp -d)"
    test_root="$(cd "$test_root" && pwd -P)"
    repository="$test_root/repository"
    worktree_directory="$test_root/repository.worktrees"
    wt="$BATS_TEST_DIRNAME/../bin/wt"

    git init -q -b main "$repository"
    git -C "$repository" config user.email test@example.com
    git -C "$repository" config user.name Test
    printf 'initial\n' > "$repository/file"
    git -C "$repository" add file
    git -C "$repository" commit -qm initial
    git -C "$repository" branch a
    git -C "$repository" branch b
    mkdir -p "$worktree_directory"
    git -C "$repository" worktree add -q "$worktree_directory/a" a
    git -C "$repository" worktree add -q "$worktree_directory/b" b

    cd "$repository"
}

teardown() {
    rm -rf "$test_root" "$worktree_directory"
}

base_selector() {
    local bin_directory="$1"

    mkdir "$bin_directory"
    printf '#!/usr/bin/env bash\ncat > "$FZF_INPUT"\nprintf "%%s\\t%%s\\n" "$FZF_SELECTION" "$FZF_SELECTION"\n' > "$bin_directory/fzf"
    chmod +x "$bin_directory/fzf"
}

@test "rm treats a supplied worktree name literally" {
    run "$wt" rm .

    [ "$status" -eq 1 ]
    [ "$output" = 'wt: no worktree found for: .' ]

    run git worktree list --porcelain

    [ "$status" -eq 0 ]
    [[ "$output" == *"worktree $worktree_directory/a"* ]]
    [[ "$output" == *"worktree $worktree_directory/b"* ]]
}

@test "add supports a primary worktree path containing a newline" {
    local newline_root newline_repository newline_worktrees bin_directory

    newline_root="$(mktemp -d)"
    newline_root="$(cd "$newline_root" && pwd -P)"
    newline_repository="$newline_root/repository"$'\n'"name"
    newline_worktrees="$newline_root/repository"$'\n'"name.worktrees"

    git init -q "$newline_repository"
    git -C "$newline_repository" config user.email test@example.com
    git -C "$newline_repository" config user.name Test
    printf 'initial\n' > "$newline_repository/file"
    git -C "$newline_repository" add file
    git -C "$newline_repository" commit -qm initial

    bin_directory="$newline_root/bin"
    base_selector "$bin_directory"

    run env -u GIT_WORKTREE_PREFIX PATH="$bin_directory:$PATH" FZF_INPUT="$newline_root/fzf-input" FZF_SELECTION=HEAD bash -c 'cd "$1" && "$2" add topic' -- "$newline_repository" "$wt"

    [ "$status" -eq 0 ]
    [ -d "$newline_worktrees/topic" ]

    printf '#!/usr/bin/env bash\nIFS= read -r -d "" choice\nprintf "%%s\\0" "$choice"\n' > "$bin_directory/fzf"
    chmod +x "$bin_directory/fzf"

    run env PATH="$bin_directory:$PATH" bash -c 'cd "$1" && "$2" jump' -- "$newline_repository" "$wt"

    [ "$status" -eq 0 ]
    [ "$output" = "$newline_repository" ]

    run env -u GIT_WORKTREE_PREFIX bash -c 'cd "$1" && "$2" rm topic' -- "$newline_repository" "$wt"

    [ "$status" -eq 0 ]
    [ ! -e "$newline_worktrees/topic" ]

    rm -rf "$newline_root" "$newline_worktrees"
}

@test "add creates a branch from the selected base" {
    local bin_directory base_commit

    git checkout -qb current
    printf 'current\n' >> file
    git commit -am current -q
    git update-ref refs/remotes/origin/main main
    git update-ref refs/remotes/upstream/master main
    base_commit="$(git rev-parse main)"

    bin_directory="$test_root/bin"
    base_selector "$bin_directory"

    run env -u GIT_WORKTREE_PREFIX PATH="$bin_directory:$PATH" FZF_INPUT="$test_root/fzf-input" FZF_SELECTION=origin/main "$wt" add topic

    [ "$status" -eq 0 ]
    [ "$(git -C "$worktree_directory/topic" rev-parse HEAD)" = "$base_commit" ]
    [ "$(git -C "$worktree_directory/topic" rev-parse --abbrev-ref HEAD)" = topic ]
    grep -Fx 'origin/main	origin/main' "$test_root/fzf-input"
    grep -Fx 'upstream/master	upstream/master' "$test_root/fzf-input"
    grep -Fx 'main	main' "$test_root/fzf-input"
    grep -Fx 'current: current	HEAD' "$test_root/fzf-input"
}

@test "add can select a branch from another worktree as its base" {
    local bin_directory base_commit

    base_commit="$(git -C "$worktree_directory/a" rev-parse HEAD)"
    bin_directory="$test_root/bin"
    base_selector "$bin_directory"

    run env -u GIT_WORKTREE_PREFIX PATH="$bin_directory:$PATH" FZF_INPUT="$test_root/fzf-input" FZF_SELECTION=a "$wt" add topic

    [ "$status" -eq 0 ]
    [ "$(git -C "$worktree_directory/topic" rev-parse HEAD)" = "$base_commit" ]
    grep -Fqx $'a\ta' "$test_root/fzf-input"
    grep -Fqx $'b\tb' "$test_root/fzf-input"
}

@test "add exits cleanly when base selection is cancelled" {
    local bin_directory

    bin_directory="$test_root/bin"
    mkdir "$bin_directory"
    printf '#!/usr/bin/env bash\nexit 130\n' > "$bin_directory/fzf"
    chmod +x "$bin_directory/fzf"

    run env -u GIT_WORKTREE_PREFIX PATH="$bin_directory:$PATH" "$wt" add topic

    [ "$status" -eq 130 ]
    [ ! -e "$worktree_directory/topic" ]
    ! git show-ref --verify --quiet refs/heads/topic
}

@test "add --remote exits cleanly when remote selection is cancelled" {
    local bin_directory

    bin_directory="$test_root/bin"
    mkdir "$bin_directory"
    printf '#!/usr/bin/env bash\nexit 130\n' > "$bin_directory/fzf"
    chmod +x "$bin_directory/fzf"

    run env PATH="$bin_directory:$PATH" "$wt" add --remote

    [ "$status" -eq 130 ]
    [ -z "$output" ]

    run git worktree list --porcelain

    [ "$status" -eq 0 ]
    [[ "$output" == *"worktree $worktree_directory/a"* ]]
    [[ "$output" == *"worktree $worktree_directory/b"* ]]
}

@test "add --remote refuses a local branch tracking a different remote" {
    local bin_directory

    git branch feature
    git remote add origin https://example.invalid/origin.git
    git remote add upstream https://example.invalid/upstream.git
    git update-ref refs/remotes/origin/feature HEAD
    git config branch.feature.remote upstream
    git config branch.feature.merge refs/heads/feature

    bin_directory="$test_root/bin"
    mkdir "$bin_directory"
    printf '#!/usr/bin/env bash\nprintf "origin/feature\\n"\n' > "$bin_directory/fzf"
    chmod +x "$bin_directory/fzf"

    run env PATH="$bin_directory:$PATH" "$wt" add --remote

    [ "$status" -eq 1 ]
    [ "$output" = "wt: local branch 'feature' tracks 'upstream/feature', not 'origin/feature'" ]
    [ ! -e "$worktree_directory/feature" ]
}

@test "commands reject unexpected trailing arguments" {
    run "$wt" add feature extra

    [ "$status" -eq 1 ]
    [ "$output" = 'wt: add accepts at most one argument' ]

    run "$wt" ls extra

    [ "$status" -eq 1 ]
    [ "$output" = 'wt: ls does not accept arguments' ]

    run "$wt" rm a extra

    [ "$status" -eq 1 ]
    [ "$output" = 'wt: rm accepts at most one argument' ]
    [ -d "$worktree_directory/a" ]
}