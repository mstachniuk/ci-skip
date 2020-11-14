#!/usr/bin/env bats

load checkout_helper

@test "should fail fast and return 42 exit code" {
  mydir="repo-commit-contains-ci-skip-1"
  # Contains [ci skip] in message body
  checkoutRevisionAndCopyScript '89e4cb4c830463466868cfebb8ad6c826285c40f' "$mydir"
  export GITHUB_ENV=foo.txt;

  run "$BATS_TMPDIR/$mydir/ci-skip/script.sh" "true" "42" "[ci skip]"

  actual=$(cat foo.txt | sed ':a;N;$!ba;s/\n/,/g') # replace new line with coma
  echo "Output:"
  echo "$output"
  echo "GITHUB_ENV: $actual"
  [ "$status" -eq 42 ]
}

@test "should fail fast and return 22 exit code" {
  mydir="repo-commit-contains-ci-skip-2"
  # Contains [ci skip] in message body
  checkoutRevisionAndCopyScript '89e4cb4c830463466868cfebb8ad6c826285c40f' "$mydir"
  export GITHUB_ENV=foo.txt;

  run "$BATS_TMPDIR/$mydir/ci-skip/script.sh" "true" "22" "[ci skip]"

  actual=$(cat foo.txt | sed ':a;N;$!ba;s/\n/,/g') # replace new line with coma
  echo "Output:"
  echo "$output"
  echo "GITHUB_ENV: $actual"
  [ "$status" -eq 22 ]
}

@test "should not fail fast and return 0 exit code" {
  mydir="repo-commit-contains-ci-skip-3"
  # Contains `Add Readme` in message subject
  checkoutRevisionAndCopyScript '84841e1cb19c7cf14edeb0b0041cead83ed2d8c7' "$mydir"
  export GITHUB_ENV=foo.txt;

  run "$BATS_TMPDIR/$mydir/ci-skip/script.sh" "true" "22" "[ci skip]"

  actual=$(cat foo.txt | sed ':a;N;$!ba;s/\n/,/g') # replace new line with coma
  echo "Output:"
  echo "$output"
  echo "GITHUB_ENV: $actual"
  [ "$status" -eq 0 ]
}

@test "should fail fast and return 22 exit code for custom commit filter" {
  mydir="repo-commit-contains-ci-skip-4"
  # Contains `Add Readme` in message subject
  checkoutRevisionAndCopyScript '84841e1cb19c7cf14edeb0b0041cead83ed2d8c7' "$mydir"
  export GITHUB_ENV=foo.txt;

  run "$BATS_TMPDIR/$mydir/ci-skip/script.sh" "true" "22" "Add"

  actual=$(cat foo.txt | sed ':a;N;$!ba;s/\n/,/g') # replace new line with coma
  echo "Output:"
  echo "$output"
  [ "$status" -eq 22 ]
}