ansible-playbook -e @vars.yml generate-inventory.yaml

ansible-playbook -i inventory.yaml -e @vars.yml deploy.yaml

openshift-install wait-for bootstrap-complete

ansible-playbook -i inventory.yaml down-bootstrap.yaml

ansible-playbook -i inventory.yaml bastion.yaml
