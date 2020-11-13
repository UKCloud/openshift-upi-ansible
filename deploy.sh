ansible-playbook -e @vars.yml generate-inventory.yaml

ansible-playbook -i inventory.yaml -e @vars.yml deploy.yaml
