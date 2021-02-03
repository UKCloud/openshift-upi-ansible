---
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
  labels:
    machineconfiguration.openshift.io/role: net2
  name: 04-net2keepalived
  selfLink: /apis/machineconfiguration.openshift.io/v1/machineconfigs/04-net2keepalived
spec:
  config:
    ignition:
      config: {}
      timeouts: {}
      version: 3.2.0
    networkd: {}
    passwd: {}
    storage:
      files:
      - contents:
          source: data:,%23%20UKCloud%20custom%20config%0Avrrp_script%20chk_ingress%20%7B%0A%20%20%20%20script%20%22%2Fusr%2Fbin%2Ftimeout%200.9%20%2Fusr%2Fbin%2Fcurl%20-o%20%2Fdev%2Fnull%20-Lfs%20http%3A%2F%2Flocalhost%3A1936%2Fhealthz%2Fready%22%0A%20%20%20%20interval%201%0A%20%20%20%20weight%2050%0A%7D%0Avrrp_instance%20%7B%7B%20.Cluster.Name%20%7D%7D_NET2INGRESS%20%7B%0A%20%20%20%20state%20BACKUP%0A%20%20%20%20interface%20ens3%0A%20%20%20%20virtual_router_id%20199%0A%20%20%20%20priority%2040%0A%20%20%20%20advert_int%201%0A%20%20%20%20authentication%20%7B%0A%20%20%20%20%20%20%20%20auth_type%20PASS%0A%20%20%20%20%20%20%20%20auth_pass%20%7B%7B%20.Cluster.Name%20%7D%7D_net2ingress_vip%0A%20%20%20%20%7D%0A%20%20%20%20virtual_ipaddress%20%7B%0A%20%20%20%20%20%20%20%20{{ os_net2_ingressVIP }}%2F24%0A%20%20%20%20%7D%0A%20%20%20%20track_script%20%7B%0A%20%20%20%20%20%20%20%20chk_ingress%0A%20%20%20%20%7D%0A%7D
        mode: 420
        overwrite: true
        path: /etc/kubernetes/static-pod-resources/keepalived/keepalived.conf.tmpl
    systemd: {}
  fips: false
  osImageURL: ""
---
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfigPool
metadata:
  name: net2
spec:
  machineConfigSelector:
    matchExpressions:
      - { key: machineconfiguration.openshift.io/role, operator: In, values: [ worker, net2 ] }
  nodeSelector:
    matchLabels:
      node-role.kubernetes.io/net2: ""
---
apiVersion: operator.openshift.io/v1
kind: IngressController
metadata:
  name: net2
  namespace: openshift-ingress-operator
spec:
  domain: net2.7969-278091.cor00005-2.cna.ukcloud.com
  namespaceSelector:
    matchLabels:
      network: net2
  nodePlacement:
    nodeSelector:
      matchLabels:
        node-role.kubernetes.io/net2: ""
  replicas: {{ net2InitialWorkerCount }}
