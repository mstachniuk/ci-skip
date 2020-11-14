#!/usr/bin/env bats

load checkout_helper


@test "should fail safe" {
  mydir="repo-fail-safe-1"
  # Contains [ci skip] in message body
  checkoutRevisionAndCopyScript '89e4cb4c830463466868cfebb8ad6c826285c40f' "$mydir"
  export GITHUB_ENV=foo.txt;

  run "$BATS_TMPDIR/$mydir/ci-skip/script.sh" "false" "42" "[ci skip]"

  echo "Output:"
  echo "$output"
  actual=$(cat foo.txt | sed ':a;N;$!ba;s/\n/,/g') # replace new line with coma
  echo "GITHUB_ENV: $actual"
  [ "$actual" = "CI_SKIP=true,CI_SKIP_NOT=false" ]
#  [ "$output" = "debug - check output" ]
  [ "$status" -eq 0 ]
}

@test "should not fail safe doesnt contains commit filter" {
  mydir="repo-fail-safe-2"
  # Contains `Add Readme` in message subject
  checkoutRevisionAndCopyScript '84841e1cb19c7cf14edeb0b0041cead83ed2d8c7' "$mydir"
  export GITHUB_ENV=foo.txt;

  run "$BATS_TMPDIR/$mydir/ci-skip/script.sh" "false" "42" "[ci skip]"

  echo "Output:"
  echo "$output"
  actual=$(cat foo.txt | sed ':a;N;$!ba;s/\n/,/g') # replace new line with coma
  echo "GITHUB_ENV: $actual"
  [ "$actual" = "CI_SKIP=false,CI_SKIP_NOT=true" ]
  [ "$status" -eq 0 ]
}

@test "should fail safe custom commit filter" {
  mydir="repo-fail-safe-3"
  # Contains `Add Readme` in message subject
  checkoutRevisionAndCopyScript '84841e1cb19c7cf14edeb0b0041cead83ed2d8c7' "$mydir"
  export GITHUB_ENV=foo.txt;

  run "$BATS_TMPDIR/$mydir/ci-skip/script.sh" "false" "42" "Add Readme"

  echo "Output:"
  echo "$output"
  actual=$(cat foo.txt | sed ':a;N;$!ba;s/\n/,/g') # replace new line with coma
  echo "GITHUB_ENV: $actual"

  [ "$actual" = "CI_SKIP=true,CI_SKIP_NOT=false" ]
  [ "$status" -eq 0 ]
}
