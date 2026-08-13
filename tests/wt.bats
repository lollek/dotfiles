#!/usr/bin/env bats

setup() {
    test_root="$(mktemp -d)"
    test_root="$(cd "$test_root" && pwd -P)"
    repository="$test_root/repository"
    worktree_directory="$test_root/repository.worktrees"
    wt="$BATS_TEST_DIRNAME/../bin/wt"

    git init -q "$repository"
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

@test "rm treats a supplied worktree name literally" {
    run "$wt" rm .

    [ "$status" -eq 1 ]
    [ "$output" = 'wt: no worktree found for: .' ]

    run git worktree list --porcelain

    [ "$status" -eq 0 ]
    [[ "$output" == *"worktree $worktree_directory/a"* ]]
    [[ "$output" == *"worktree $worktree_directory/b"* ]]
}