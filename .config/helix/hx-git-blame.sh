#!/bin/bash
#
# Script to extract PR/commit URL and information from git blame for a specific file line
# Originally from: https://github.com/helix-editor/helix/discussions/6421#discussioncomment-12502299

set -e

# Initialize variables
DEBUG=0
URL_ONLY=0
FILE=""
LINE=""
VERSION="1.1.0"

# Function to display help message
show_help() {
  cat << EOF
Usage: $(basename "$0") [OPTIONS] <file_path> <line_number>
   OR: $(basename "$0") [OPTIONS] <line_number> <file_path>

Extract PR/commit information and URL from git blame for a specific file line.
By default, outputs author name, time since commit, commit message, and URL.

Options:
  -h, --help       Show this help message and exit
  -d, --debug      Enable debug output
  -v, --version    Show version information and exit
  -u, --url-only   Output only the URL, suitable for opening in browser
EOF
  exit 0
}

# Function to display version information
show_version() {
  echo "$(basename "$0") version $VERSION"
  exit 0
}

# Function to print debug messages when debug mode is enabled
debug() {
  if [ $DEBUG -eq 1 ]; then
    echo "[DEBUG] $1" >&2
  fi
}

# Function to display error messages and exit
error() {
  echo "ERROR: $1" >&2
  exit 1
}

# Check if git is available
command -v git >/dev/null 2>&1 || error "git command not found. Please install git."

# Process command line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      show_help
      ;;
    -d|--debug)
      DEBUG=1
      shift
      ;;
    -v|--version)
      show_version
      ;;
    -u|--url-only)
      URL_ONLY=1
      shift
      ;;
    *)
      # Try to determine if the argument is a line number or file path
      if [[ "$1" =~ ^[0-9]+$ ]]; then
        # It's a number, assume it's a line number
        LINE="$1"
      else
        # It's not a number, assume it's a file path
        FILE="$1"
      fi
      shift
      ;;
  esac
done

# Validate required arguments
if [ -z "$FILE" ] || [ -z "$LINE" ]; then
  error "Missing required arguments. See --help for usage."
fi

debug "File: $FILE"
debug "Line: $LINE"

# Check if we're in a git repository
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || error "Not in a git repository"

# Get git root directory
GIT_ROOT=$(git rev-parse --show-toplevel)
debug "Git root: $GIT_ROOT"

# Resolve file path relative to git root if needed
if [ ! -f "$FILE" ]; then
  # Try with git root
  if [ -f "$GIT_ROOT/$FILE" ]; then
    FILE="$GIT_ROOT/$FILE"
    debug "Resolved file path: $FILE"
  else
    error "File does not exist: $FILE (tried $GIT_ROOT/$FILE)"
  fi
fi

# Get the git blame info for the specified line
blame_info=$(git blame -L "${LINE},${LINE}" "${FILE}" 2>&1) || error "Failed to get git blame info: $blame_info"
debug "Blame info: $blame_info"

# Extract the commit ID (possibly shortened)
short_commit_id=$(echo "$blame_info" | awk '{print $1}')
[ -n "$short_commit_id" ] || error "Could not extract commit ID from blame output"
debug "Short Commit ID: $short_commit_id"

# Get the full commit hash
full_commit_id=$(git rev-parse "$short_commit_id" 2>&1) || error "Failed to get full commit hash: $full_commit_id"
debug "Full Commit ID: $full_commit_id"

# Get the current branch name
current_branch=$(git symbolic-ref --short HEAD 2>&1) || error "Failed to get current branch: $current_branch"
debug "Current branch: $current_branch"

# Get the remote name tracking the current branch
remote_name=$(git config --get branch."$current_branch".remote 2>&1) || error "Failed to get remote name for branch '$current_branch': $remote_name"
debug "Remote name for current branch: $remote_name"

# Get the remote URL of that remote
remote_url=$(git remote get-url "$remote_name" 2>&1) || error "Failed to get remote URL for remote '$remote_name': $remote_url"
debug "Remote URL: $remote_url"

# Process remote URL
process_remote_url() {
  local url="$1"
  
  # Convert SSH URL to HTTPS if needed
  if [[ $url == git@* ]]; then
    local domain=$(echo "$url" | cut -d'@' -f2 | cut -d':' -f1)
    local repo_path=$(echo "$url" | cut -d':' -f2)
    url="https://${domain}/${repo_path}"
    debug "Converted SSH URL to HTTPS"
  fi

  # Remove .git suffix if present
  url=${url%.git}

  # Remove any username@ part from the URL
  url=$(echo "$url" | sed -E 's|https://[^@]+@|https://|')
  
  echo "$url"
}

remote_url=$(process_remote_url "$remote_url")
debug "Processed remote URL: $remote_url"

# Get author name, time since commit, and commit message
author_name=$(git show -s --format="%an" "$full_commit_id")
commit_time=$(git show -s --format="%ar" "$full_commit_id") # already in "X time ago" format
commit_msg=$(git show -s --format="%s" "$full_commit_id")
debug "Author: $author_name"
debug "Time: $commit_time"
debug "Subject: $commit_msg"

# Get the full commit message
full_commit_msg=$(git show -s --format=%B "$full_commit_id" 2>&1) || error "Failed to get commit message"
if [ $DEBUG -eq 1 ]; then
  debug "Full commit message:"
  echo "$full_commit_msg" | sed 's/^/    /' >&2
fi

# Try to find PR number in commit message (multiple formats)
find_pr_number() {
  local msg="$1"
  local pr_number=""
  
  # Format: "Merge pull request #123"
  pr_number=$(echo "$msg" | grep -oE "Merge pull request #[0-9]+" | grep -oE "[0-9]+" | head -1)
  
  # Format: "PR #123:"
  if [ -z "$pr_number" ]; then
    pr_number=$(echo "$msg" | grep -oE "PR #[0-9]+" | grep -oE "[0-9]+" | head -1)
  fi
  
  # Format: "(#123)"
  if [ -z "$pr_number" ]; then
    pr_number=$(echo "$msg" | grep -oE "\\(#[0-9]+\\)" | grep -oE "[0-9]+" | head -1)
  fi
  
  # Format: "Merged PR 123:"
  if [ -z "$pr_number" ]; then
    pr_number=$(echo "$msg" | grep -oE "Merged PR [0-9]+" | grep -oE "[0-9]+" | head -1)
  fi
  
  echo "$pr_number"
}

pr_number=$(find_pr_number "$full_commit_msg")
debug "PR number found: $pr_number"

# Determine URL type based on repository host
get_pull_path() {
  if [[ "$remote_url" == *"github.com"* ]]; then
    echo "pull"
  elif [[ "$remote_url" == *"dev.azure.com"* ]]; then
    echo "pullrequest"
  else
    echo "pull"  # Default for most Git hosts
  fi
}

# Generate URL
if [ -n "$pr_number" ]; then
  pull_path=$(get_pull_path)
  url="${remote_url}/${pull_path}/${pr_number}"
  debug "Generated PR URL: $url"
else
  url="${remote_url}/commit/${full_commit_id}"
  debug "Generated commit URL: $url"
fi

# Output based on mode
if [ $URL_ONLY -eq 1 ]; then
  # URL-only mode
  echo "$url"
else
  # Default rich output
  echo "$author_name, $commit_time • $commit_msg"
  echo "$url"
fi