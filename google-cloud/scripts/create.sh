#!/usr/bin/env bash

####################################
# Creates resources with Terraform.
####################################

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o nounset
set -o pipefail

# Locate the root directory
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# shellcheck source=scripts/common.sh
source "${ROOT}/scripts/common.sh"

# Initialize and run Terraform
(cd "${ROOT}/terraform"; terraform init -input=false)
(cd "${ROOT}/terraform"; terraform apply -input=false -auto-approve)

# Get cluster credentials
GET_CREDS="$(terraform output --state=terraform/terraform.tfstate get_credentials)"
${GET_CREDS}