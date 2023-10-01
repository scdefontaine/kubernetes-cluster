#!/usr/bin/env bash

######################################################################
# Validate that all resources have been created and work as expected.
######################################################################

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -euo pipefail

# Directory of this script.
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# shellcheck source=scripts/common.sh
source "$ROOT"/scripts/common.sh

# Ensure the bastion SSH tunnel/proxy is up/running
# shellcheck source=scripts/proxy.sh
source "$ROOT"/scripts/proxy.sh

# Set the HTTPS_PROXY env var to allow kubectl to bounce through
# the bastion host over the locally forwarded port 8888.
export HTTPS_PROXY=localhost:8888