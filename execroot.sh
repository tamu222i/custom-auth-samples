#!/bin/bash -xe
export PATH=$PATH:/usr/local/bin
DOCKER_REPO=custom-auth

yum -y install python3 wget git
pip3 install ansible-bender selinux ansible testinfra requests
wget https://download.opensuse.org/repositories/devel%3A/kubic%3A/libcontainers%3A/stable/CentOS_7/x86_64/conmon-2.0.21-1.el7.x86_64.rpm
rpm -ivh conmon-2.0.21-1.el7.x86_64.rpm
cd /etc/yum.repos.d/
wget https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/CentOS_7/devel:kubic:libcontainers:stable.repo
yum -y install buildah podman
sed -i -e "s/^mountopt = \"nodev,metacopy=on\"/mountopt = \"nodev\"/" /etc/containers/storage.conf
systemctl start podman
cd /home/cloud-user/workspace/ansible
#ansible-bender build main.yml 
ansible-bender --debug build main.yml 

### test
podman run -d -p 80:80 tamu222i:$DOCKER_REPO /usr/bin/node /opt/app/instagram/app.js
### need service-account.json
#pytest -v ../testinfra/test_container.py


COMMIT_ID="$(git rev-parse --short=7 HEAD)"
podman tag tamu222i:$DOCKER_REPO docker.io/tamu222i/$DOCKER_REPO:latest
podman tag tamu222i:$DOCKER_REPO docker.io/tamu222i/$DOCKER_REPO:$COMMIT_ID
podman login -u tamu222i -p `cat ../decrypted-data.txt` docker.io
podman push docker.io/tamu222i/$DOCKER_REPO:latest
podman push docker.io/tamu222i/$DOCKER_REPO:$COMMIT_ID
