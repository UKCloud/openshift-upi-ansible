cd pre-files

curl https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.6.4/openshift-install-mac-4.6.4.tar.gz -o openshift-install-mac-4.6.4.tar.gz

tar -xzf openshift-install-mac-4.6.4.tar.gz

curl https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.6/4.6.1/rhcos-4.6.1-x86_64-openstack.x86_64.qcow2.gz -o rhcos-4.6.1-x86_64-openstack.x86_64.qcow2.gz

gunzip rhcos-4.6.1-x86_64-openstack.x86_64.qcow2.gz

ssh-keygen -t rsa -b 4096 -N '' -f openshift_key

cp openshift_key.pub ../files/pubkey.pem
