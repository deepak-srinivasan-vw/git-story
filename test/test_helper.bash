PROJECT_HOME=$(pwd)
SOURCE_DIR="$PROJECT_HOME/source"
TEST_DIR="$PROJECT_HOME/test"
TEST_REPO="$TEST_DIR/test-repo"

setup(){
  teardown
  cd $SOURCE_DIR
  ./install.sh

  mkdir "$TEST_REPO"
  cp "$TEST_DIR/test-git-authors" "$TEST_REPO/.git-authors"
  export GIT_DUET_AUTHORS_FILE=$TEST_REPO/.git-authors
  cd $TEST_REPO
  git init
}

teardown(){
  cd $SOURCE_DIR
  ./uninstall.sh
  rm -rf "$TEST_REPO"
}

assert_last_commit_message_equals() {
  actual_message="$(git reflog -1 | sed 's/^.*: //')"
  assert_equals "$actual_message" "$1"
}

assert_response() {
  if [ "$last_run_exit_status" -ne 0 ]; then
    fail "fails with $last_run_exit_status"
  fi

  local expected="$1"
  assert_equals "$expected" "$output"
}

assert_empty() {
  if [ "$1" != "" ]; then
    echo "Actual value not empty: $1"
    return 1
  fi
}

assert_equals() {
  if [ "$1" != "$2" ]; then
    echo "expected: $1"
    echo "actual:   $2"
    return 1
  fi
}



