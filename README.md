# openshift-upi-ansible
OpenShift Ansible playbooks to provision infrastructure on a cloud platform

To run deployment fill out `vars.yml` and `files/pull-secret.txt`, and then run:

`./deploy.sh`

The rhcos image, floating IP creation and pull-secret are not currently part of the code and need to be created/downloaded manually, and then referenced in `vars.yml`

Tested with ...

```
PIP Package            Version
---------------------- ---------
ansible                2.10.5
ansible-base           2.10.4

Collection        Version
----------------- -------
community.general 2.4.0
openstack.cloud   1.2.0
```

## Rough method for destroying cluster (for testing ONLY)
```
oc delete IngressControllers --all -n openshift-ingress-operator      
sleep 10
oc delete MachineSets --all -n openshift-machine-api
sleep 60
# Default IC never dies ...
oc scale IngressControllers default --replicas=0 -n openshift-ingress-operator
# Wait for workers/infra/net2 to vanish - last worker takes ages...
watch -n5 oc get nodes

ansible-playbook -i ./inventory.yaml ./down-compute-nodes.yaml
ansible-playbook -i ./inventory.yaml ./down-control-plane.yaml
ansible-playbook -i ./inventory.yaml ./down-bootstrap.yaml
ansible-playbook -i ./inventory.yaml ./down-bastion.yaml
# The down-network playbook needs to be run twice due to ha_router port removal occasionally failing
ansible-playbook -e @vars.yml -i ./inventory.yaml ./down-network.yaml
ansible-playbook -e @vars.yml -i ./inventory.yaml ./down-network.yaml
ansible-playbook -e @vars.yml -i ./inventory.yaml ./down-server-groups.yaml
ansible-playbook -i ./inventory.yaml ./down-security-groups.yaml
```

## Destroying state in directory to prepare for a fresh test install (at your own risk - for testing only!):
```
rm *.ign *.json inventory.yaml openshift_ke* .openshift_install_state.json; rm -rf ./auth
```
