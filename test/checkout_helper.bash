#!/bin/bash

# Checkout revision $1 into directory $2
function checkoutRevisionAndCopyScript() {
  mkdir "$BATS_TMPDIR/$2"
  cd "$BATS_TMPDIR/$2"
  git clone https://github.com/mstachniuk/ci-skip
  cd ci-skip
  git checkout "$1"
  pwd
  ls "$BATS_TEST_DIRNAME"
  cp "$BATS_TEST_DIRNAME/../script.sh" .
}