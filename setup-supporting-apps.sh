#!/usr/bin/env bash
# setup-supporting-apps.sh
#
# Sets up the supporting-apps folder inside the Notes-Taking app and clones
# the three supporting repositories (Hungama, E-Commerce, Appointment-Booking).
#
# Usage:
#   ./setup-supporting-apps.sh

set -euo pipefail

# ----- Configuration ---------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${SCRIPT_DIR}/supporting-apps"

REPOS=(
  "https://github.com/anushaviswanathan2002/Hungama-app.git"
  "https://github.com/anushaviswanathan2002/E-Commerce-app.git"
  "https://github.com/anushaviswanathan2002/Appointment-Booking-app.git"
)

# ----- Helpers ---------------------------------------------------------------

log()  { printf "\033[1;34m[setup]\033[0m %s\n" "$*"; }
ok()   { printf "\033[1;32m[setup]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[setup]\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31m[setup]\033[0m %s\n" "$*" >&2; }

# ----- Pre-flight ------------------------------------------------------------

if ! command -v git >/dev/null 2>&1; then
  err "git is required but was not found in PATH."
  exit 1
fi

# ----- Create the supporting-apps folder -------------------------------------

if [ -d "${TARGET_DIR}" ]; then
  warn "Folder already exists: ${TARGET_DIR}"
  warn "Existing contents will be preserved; repositories will be skipped if already cloned."
else
  log "Creating folder: ${TARGET_DIR}"
  mkdir -p "${TARGET_DIR}"
  ok "Folder created."
fi

cd "${TARGET_DIR}"

# ----- Clone each repository -------------------------------------------------

for REPO_URL in "${REPOS[@]}"; do
  REPO_NAME="$(basename "${REPO_URL}" .git)"

  if [ -d "${REPO_NAME}" ]; then
    warn "Skipping '${REPO_NAME}' (already present)."
    continue
  fi

  log "Cloning ${REPO_NAME}..."
  if git clone "${REPO_URL}"; then
    ok "Cloned ${REPO_NAME}."
  else
    err "Failed to clone ${REPO_NAME} from ${REPO_URL}."
    exit 1
  fi
done

ok "All done. Supporting apps are available in: ${TARGET_DIR}"