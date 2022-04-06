# openshift-upi-ansible
OpenShift Ansible playbooks to provision infrastructure on a cloud platform

To run deployment fill out `vars.yml` and `files/pull-secret.txt`, and then run:

`./deploy.sh`

The rhcos image and floating IP creation are not currently part of the code and need to be created/uploaded, and then referenced in `vars.yml`

Tested with the versions in `pip-requirements.txt` ...

```
pip install -r pip-requirements.txt
```

## Rough method for destroying cluster (for testing ONLY)
```
oc delete project ukc-ingress 
oc delete MachineSets --all -n openshift-machine-api
oc scale IngressControllers --all --replicas=0 -n openshift-ingress-operator
oc delete pdb prometheus-adapter thanos-querier-pdb alertmanager-main prometheus-k8s -n openshift-monitoring
oc delete pdb prometheus-user-workload thanos-ruler-user-workload -n openshift-user-workload-monitoring
# Wait for workers/infra/net2 to vanish - last worker takes ages...
watch -n5 oc get nodes

ansible-playbook -i ./inventory.yaml ./down-compute-nodes.yaml
ansible-playbook -i ./inventory.yaml ./down-control-plane.yaml
ansible-playbook -e @vars.yml -i ./inventory.yaml ./down-bootstrap.yaml
ansible-playbook -i ./inventory.yaml ./down-bastion.yaml
ansible-playbook -i ./inventory.yaml ./down-loadbalancers.yaml
# The down-network playbook needs to be run twice due to ha_router port removal occasionally failing for net2/eg deployments
ansible-playbook -e @vars.yml -i ./inventory.yaml ./down-network.yaml
ansible-playbook -e @vars.yml -i ./inventory.yaml ./down-network.yaml
ansible-playbook -e @vars.yml -i ./inventory.yaml ./down-server-groups.yaml
ansible-playbook -i ./inventory.yaml ./down-security-groups.yaml
```

## Destroying state in directory to prepare for a fresh test install (at your own risk - for testing only!):
```
rm *.ign *.json inventory.yaml openshift_ke* .openshift_install_state.json; rm -rf ./auth
```
