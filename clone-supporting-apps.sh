#!/usr/bin/env bash
# clone-supporting-apps.sh
#
# Clones the three sibling basic-level React apps (Hungama, E-Commerce,
# Appointment-Booking) into ./supporting-apps/ inside this Notes-Taking
# repo so they can be inspected, run, or worked on side-by-side.
#
# Usage:
#   ./clone-supporting-apps.sh                                  # clone into supporting-apps/ on bc/217fd4e8-create-basic-level
#   ./clone-supporting-apps.sh ../siblings                      # custom target dir
#   ./clone-supporting-apps.sh supporting-apps main             # different branch
#
# The default branch (bc/217fd4e8-create-basic-level) is the one that
# contains the React app code. `main` on those repos only has the initial
# empty commit.
#
# The script is idempotent: if a repo is already cloned at the target path,
# it is left untouched.

set -euo pipefail

TARGET_DIR="${1:-supporting-apps}"
BRANCH="${2:-bc/217fd4e8-create-basic-level}"

# Keep this in sync with this repo's origin (anushaviswanathan2002/*).
OWNER="anushaviswanathan2002"

REPOS=(
  "Hungama-app"
  "E-Commerce-app"
  "Appointment-Booking-app"
)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${SCRIPT_DIR}/${TARGET_DIR}"

mkdir -p "${DEST}"

echo "Target directory: ${DEST}"
echo "Branch:           ${BRANCH}"
echo

for repo in "${REPOS[@]}"; do
  url="https://github.com/${OWNER}/${repo}.git"
  target="${DEST}/${repo}"

  if [ -d "${target}/.git" ]; then
    echo "[skip] ${repo} already cloned at ${target}"
    continue
  fi

  if [ -d "${target}" ]; then
    echo "[warn] ${target} exists but is not a git repo — leaving untouched"
    continue
  fi

  echo "[clone] ${url} -> ${target}"
  git clone --branch "${BRANCH}" --single-branch "${url}" "${target}"
done

echo
echo "Done. Contents of ${DEST}:"
ls -1 "${DEST}"
