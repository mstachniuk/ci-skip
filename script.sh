
fail_fast=$1
exit_code=$2
commit_filter=$3

# Based on: https://github.com/marketplace/actions/skip-based-on-commit-message
last_commit_log=$(git log -1 --pretty=format:"%s %b")

readonly local is_merge_commit=$(echo "$last_commit_log" | egrep -c "Merge [a-zA-Z0-9]* into [a-zA-Z0-9]*")
if [[ "$is_merge_commit" -eq 1 ]]; then
  readonly local commit_id=$(echo "$last_commit_log" | sed 's/Merge //' | sed 's/ into [a-zA-Z0-9]*//')
  last_commit_log=$(git log -1 --pretty="%s %b" $commit_id)
fi
echo "last commit log: $last_commit_log"

readonly local filter_count=$(echo "$last_commit_log" | fgrep -c "$commit_filter")
echo "number of occurrences of '$commit_filter' in '$last_commit_log': $filter_count"

if [[ "$filter_count" -eq 0 ]]; then
  echo "all good, continue"
else
  if [[ $fail_fast == 'true' ]]; then
    echo "the last commit log \"$last_commit_log\" contains \"$commit_filter\", stopping"
    # It's impossible to finish workflow with success, so exiting using exit-code
    exit "$exit_code"
  else
    echo "the last commit log \"$last_commit_log\" contains \"$commit_filter\", setting environment variables:"
    echo "CI_SKIP=true"
    echo "CI_SKIP_NOT=false"
    echo "CI_SKIP=true" >> $GITHUB_ENV
    echo "CI_SKIP_NOT=false" >> $GITHUB_ENV
  fi
fi