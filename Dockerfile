# FROM ansible-runner:latest
FROM docker.io/ansible/ansible-runner

WORKDIR /workspace/git-src
ADD . /usr/local/playbooks

# Upgrade pip
RUN pip3 install --upgrade pip

WORKDIR /usr/local/playbooks
ENTRYPOINT ./deploy.sh
