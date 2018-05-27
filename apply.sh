#!/bin/bash
set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd "$DIR" > /dev/null

terraform init -get=true -get-plugins=true -upgrade=true
terraform apply -var-file variables.tfvars.json -auto-approve

popd > /dev/null
