#!/bin/bash

# Exit on any error
set -eux

export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/
export PATH=/usr/local/bin:$PATH
export csstudio_version=$(curl https://raw.githubusercontent.com/ESSICS/org.csstudio.ess.product/production/features/org.csstudio.ess.product.configuration.feature/rootfiles/ess-version.txt)

# Update all packages
yum update -y
yum install -y xorg-x11-server-Xvfb
yum clean all
# Move uploaded ansible files to /etc
mkdir /etc/ansible

ANSIBLE_VERSION=2.3.1.0


export
# Install ansible-playbook and ansible-galaxy PEX files
for exe in ansible-playbook ansible-galaxy
do
  curl --fail -o /usr/local/bin/${exe} https://artifactory.esss.lu.se/artifactory/swi-pkg/ansible-releases/${ANSIBLE_VERSION}/${exe}
  chmod a+x /usr/local/bin/${exe}
done

# Generate ansible files to be ran
cat << EOF > /etc/ansible/requirements.yml
- src: git+https://bitbucket.org/europeanspallationsource/ics-ans-role-oracle-jdk
- src: git+https://bitbucket.org/europeanspallationsource/ics-ans-role-repository
- src: git+https://dat12jol@bitbucket.org/dat12jol/ics-ans-role-cs-studio
EOF

cat << EOF > /etc/ansible/hosts
localhost ansible_connection=local
EOF

cat << EOF > /etc/ansible/jesperrun.yml
- hosts: all
  become: yes
  roles:
    - role: ics-ans-role-cs-studio
EOF

# Start virtual display
/usr/bin/Xvfb :99 -screen 1 1024x768x24 &
export DISPLAY=:99

# Run things
ansible-galaxy install -r /etc/ansible/requirements.yml -p /etc/ansible/roles
ansible-playbook /etc/ansible/jesperrun.yml
xvfb-run /usr/local/bin/css &

sleep 45

pkill -9 xvfb-run
pkill -9 css
pkill -9 Xvfb

if ! sudo grep "$(date "+SESSION %Y-%m-%d")" ~/.ess-cs-studio/.metadata/.log
then
      exit 1
fi
