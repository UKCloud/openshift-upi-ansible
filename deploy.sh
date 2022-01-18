#!/bin/sh

set -xe

ssh-keygen -t ed25519 -N '' -f openshift_key -C "$(date +%d-%m-%y)"

cp openshift_key.pub files/pubkey.pem

ansible-galaxy collection install -r requirements.yml

ansible-playbook -e @vars.yml generate-clouds.yaml

ansible-playbook -e @vars.yml generate-inventory.yaml

ansible-playbook -e @vars.yml dns.yaml

ansible-playbook -i inventory.yaml -e @vars.yml deploy.yaml

openshift-install wait-for bootstrap-complete

ansible-playbook -i inventory.yaml -e @vars.yml down-bootstrap.yaml
