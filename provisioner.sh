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
echo $GIT_BRANCH # Add in git branch feature 
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


# echo "Installing development tools in RHEL 8"
# echo "install node js and npm"
sudo dnf groupinstall "Development Tools" 
sudo dnf module install nodejs -y

echo "install loopback cli"
sudo npm install -g @loopback/cli -y

echo "loopback generate example project"
lb4 app loopback-example -y