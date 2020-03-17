#! /bin/bash   
set -m

echo "Setting environment variable"

echo $RH_ACCOUNT_USERNAME
echo $RH_ACCOUNT_PASSWORD
echo $ORG_ID
echo $Key_NAME
echo $DOCKER_HUB_USERNAME
echo $DOCKER_HUB_PASSWORD
echo $DOCKER_IMAGE_NAME
echo $DOCKER_IMAGE_TAG
echo $GIT_REPO_URL
echo $TARGET_PLATFORM

echo "Checking this OS image and kernel version"
cat /etc/redhat-release
if ! subscription-manager status; then
sudo subscription-manager register --username=$RH_ACCOUNT_USERNAME --password=$RH_ACCOUNT_PASSWORD --auto-attach
sudo  subscription-manager register --org=$ORG_ID --activationkey=$Key_NAME
sudo subscription-manager attach
sudo subscription-manager list
fi
sudo yum update -y
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
echo "Cannot install directly, faced error while install containerd.io"
echo "current work around is to manually install containerd.io"
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf repolist -v
sudo dnf list docker-ce --showduplicates | sort -r
sudo dnf install docker-ce-3:19.03.8-3.el7
sudo dnf install --nobest docker-ce -y
sudo dnf install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm -y
sudo systemctl enable docker
sudo systemctl start docker

echo "validate docker running successfully"
sudo docker run hello-world

echo "groupadd docker user, so we don't run permission with sudo"
sudo groupadd docker
sudo usermod -aG docker vagrant

echo "getting root permission"
export DOCKER_CLI_EXPERIMENTAL=enabled

echo "Install qemu for RHEL 8"
sudo yum install qemu-kvm -y
echo "Checking qemu version"
sudo /usr/libexec/qemu-kvm --version
sudo yum info qemu-kvm

echo "Checking Kernel Version"
uname -r

echo "login docker "
sudo docker login -u $DOCKER_HUB_USERNAME --password=$DOCKER_HUB_PASSWORD

echo "Install jq "
sudo yum install jq -y

# Using jq to persist the buildx changes
sudo jq '. + {"experimental": "enabled"}' /root/.docker/config.json > abc.json
cat abc.json
sudo mv abc.json /root/.docker/config.json

# Add dns record for daemon.json
echo '{"dns":["8.8.8.8","8.8.4.4"]}' | sudo tee -a /etc/docker/daemon.json

echo "stop RHEL firewall"
sudo systemctl stop firewalld

echo "make docker bridge able to access internet"
sudo sysctl net.ipv4.conf.all.forwarding=1
sudo iptables-save > your-current-iptables.rules
sudo iptables --flush
sudo iptables -P FORWARD ACCEPT
sudo iptables -I INPUT -j ACCEPT
sudo iptables -I OUTPUT -j ACCEPT

echo "Restart docker to make effect"
sudo systemctl restart docker

echo "Enable DOCKER_CLI_EXPERIMENTAL Flag"
export DOCKER_CLI_EXPERIMENTAL=enabled
echo 'export DOCKER_CLI_EXPERIMENTAL=enabled' > .bash_profile
source .bash_profile

echo "validate buildx command"
echo $DOCKER_CLI_EXPERIMENTAL
docker buildx build

echo "Enable binfmt_misc to run non-native Docker images"
sudo docker run --restart always --privileged multiarch/qemu-user-static --reset -p yes

echo "Checking binfmt_misc"
ls /proc/sys/fs/binfmt_misc/
cat /proc/sys/fs/binfmt_misc/qemu-aarch64

echo "Creating a Buildx Builder"
docker buildx create --use --name mybuilder
docker buildx inspect --bootstrap
docker buildx ls

echo "Installing development tools in RHEL 8"
sudo yum install git -y

echo "Git clone the url"
git clone $GIT_REPO_URL ./example

echo "Build Multiarch Image using Dockerfile and Buildx"
cd /home/vagrant/example && docker buildx build -t $DOCKER_HUB_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG --platform=$TARGET_PLATFORM . --push
