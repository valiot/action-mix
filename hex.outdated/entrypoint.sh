#!/bin/bash
set -e
set -o pipefail

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN env variable."
  exit 1
fi

if [[ -z "$GITHUB_REPOSITORY" ]]; then
  echo "Set the GITHUB_REPOSITORY env variable."
  exit 1
fi

URI=https://api.github.com
API_VERSION=v3
API_HEADER="Accept: application/vnd.github.${API_VERSION}+json; application/vnd.github.antiope-preview+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

post_result() {
  if hex_output=$(sh -c "mix hex.outdated $*"); then
    exit 0
  else
  hex_output=${hex_output//
/\\\n} # \n (newline)
  curl -sSL -H "${AUTH_HEADER}" -H "${API_HEADER}" -d "{\"body\": \"Outdated Packages:\n\`\`\`\n${hex_output}\n\`\`\`\"}" -H "Content-Type: application/json" -X POST "${URI}/repos/${GITHUB_REPOSITORY}/issues/${NUMBER}/comments"
  exit 1
  fi
}

main() {
  # Validate the GitHub token.
  curl -o /dev/null -sSL -H "${AUTH_HEADER}" -H "${API_HEADER}" "${URI}/repos/${GITHUB_REPOSITORY}" || { echo "Error: Invalid repo, token or network issue!";  exit 1; }

  # Get the pull request number.
  NUMBER=$(jq --raw-output .number "$GITHUB_EVENT_PATH")


  echo "running $GITHUB_ACTION for PR #${NUMBER}"

  post_result;
}

main