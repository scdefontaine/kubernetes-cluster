#!/usr/bin/env bash

#######################################################
# Sets up the gcloud compute ssh proxy to the bastion.
#######################################################

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -euo pipefail

# Directory of this script.
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# shellcheck source=scripts/common.sh
source "$ROOT"/scripts/common.sh

export HTTPS_PROXY=localhost:8888

echo "Detecting SSH Bastion Tunnel/Proxy"
if [[ ! "$(pgrep -f L8888:127.0.0.1:8888)" ]]; then
  echo "Did not detect a running SSH tunnel.  Opening a new one."
  # shellcheck disable=SC2091
  export BASTION_CMD="$(terraform output --state=terraform/terraform.tfstate bastion_ssh)"
  $BASTION_CMD -f tail -f /dev/null
  echo "SSH Tunnel/Proxy is now running."
else
  echo "Detected a running SSH tunnel.  Skipping."
fi