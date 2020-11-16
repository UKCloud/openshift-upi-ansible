ssh-keygen -t rsa -b 4096 -N '' -f ssh-key/openshift_key

cp ssh-key/openshift_key.pub files/pubkey.pem
