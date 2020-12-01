# FROM ansible-runner:latest
FROM docker.io/ansible/ansible-runner

WORKDIR /workspace/git-src
ADD . /usr/local/playbooks

# Upgrade pip
RUN pip3 install --upgrade pip

ENTRYPOINT /usr/local/playbooks/deploy.sh