#!/bin/bash
terraform init -get=true -get-plugins=true -upgrade=true
terraform apply -var-file variables.tfvars.json -auto-approve
