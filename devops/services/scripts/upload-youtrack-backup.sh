#!/bin/sh

HOST=$(terraform output -json | jq -r '.youtrack_public_ip.value')
KEY=$(terraform output -json | jq -r '.youtrack_private_key_path.value')
FILENAME=$(basename $1)

scp -i $KEY $1 ec2-user@$HOST:/tmp
ssh -i $KEY ec2-user@$HOST "sudo mv /tmp/$FILENAME /youtrack/backups && sudo chown -R 13001:13001 /youtrack/backups/$FILENAME"
