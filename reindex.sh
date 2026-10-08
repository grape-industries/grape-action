#!/usr/bin/env bash
# Asks Grape to re-index one GitHub project. Grape answers 400 when the branch is not the one the project
# follows, and skips the clone when the commit is already indexed. Any 4xx or 5xx fails the step.
# Needs only bash and curl.
set -euo pipefail

: "${GRAPE_PROJECT:?set the project input}"
: "${GRAPE_TOKEN:?set the token input}"
url="${GRAPE_URL:-https://grape-inc.in}"
branch="${GRAPE_BRANCH:-}"
# JSON string: escape backslashes and quotes.
branch="${branch//\\/\\\\}"
branch="${branch//\"/\\\"}"
body="{}"
[[ -n $branch ]] && body="{\"branch\":\"$branch\"}"

echo "Re-indexing Grape project $GRAPE_PROJECT (branch ${GRAPE_BRANCH:-default})"
if ! reply=$(curl -sS --fail-with-body --max-time 900 -X POST "${url%/}/grape/$GRAPE_PROJECT/reindex" \
  -H "Authorization: Bearer $GRAPE_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$body"); then
  echo "::error::Grape refused the re-index: $reply"
  exit 1
fi

if [[ $reply =~ \"skipped\":\"([^\"]*)\" ]]; then
  echo "Nothing to do: ${BASH_REMATCH[1]}"
elif [[ $reply =~ \"commit\":\"([0-9a-f]{7}) ]]; then
  echo "Re-indexed at commit ${BASH_REMATCH[1]}"
else
  echo "Re-indexed"
fi
