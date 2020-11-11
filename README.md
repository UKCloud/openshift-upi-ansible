# openshift-upi-ansible
OpenShift Ansible playbooks to provision infrastructure on a cloud platform

To generate ignition config and manifests necessary to run the deployment ansible playbooks fill out vars.yml and then run:

ansible-playbook -e @vars.yml manifests.yaml

The rhcos image, clouds.yaml, pull-secret and ssh key are not currently part of the code and need to be created/downloaded manually.
