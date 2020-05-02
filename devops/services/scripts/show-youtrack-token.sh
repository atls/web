#!/bin/sh

HOST=$(terraform output -json | jq -r '.youtrack_public_ip.value')
KEY=$(terraform output -json | jq -r '.youtrack_private_key_path.value')

ssh -i $KEY ec2-user@$HOST "sudo cat /youtrack/conf/internal/services/configurationWizard/wizard_token.txt"
