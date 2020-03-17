# -*- mode: ruby -*-
# vi: set ft=ruby :

# options are documented and commented below. For a complete reference,
# please see the online documentation at vagrantup.com.

# Inspired by 
# 1. https://mirailabs.io/blog/multiarch-docker-with-buildx/
# 2. https://nexus.eddiesinentropy.net/2020/01/12/Building-Multi-architecture-Docker-Images-With-Buildx/#Software-Requirements-for-Buildx-Non-Native-Architecture-Support
# 3. https://printhelloworld.de/posts/working-with-redhat-linux-in-vagrant/

# Every Vagrant development environment requires a box. You can search for
# boxes at https://vagrantcloud.com/search.
VM_BOX  =  "generic/rhel8"

Vagrant.configure(2) do |config|
  config.vm.box = VM_BOX
  config.ssh.extra_args = ["-t", "cd /home/vagrant; bash --login"] #https://stackoverflow.com/questions/17864047/automatically-chdir-to-vagrant-directory-upon-vagrant-ssh
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048  
    vb.cpus = 4
  end
  config.vm.provision 'shell' do |s| 
     s.path = 'provisioner.sh'
     s.env = { "RH_ACCOUNT_USERNAME"=>ENV['RH_ACCOUNT_USERNAME'], "RH_ACCOUNT_PASSWORD"=>ENV['RH_ACCOUNT_PASSWORD'], "ORG_ID":ENV['ORG_ID'], "Key_NAME":ENV['Key_NAME'], "DOCKER_HUB_USERNAME":ENV['DOCKER_HUB_USERNAME'], "DOCKER_HUB_PASSWORD":ENV['DOCKER_HUB_PASSWORD'], "DOCKER_IMAGE_NAME":ENV['DOCKER_IMAGE_NAME'], "DOCKER_IMAGE_TAG":ENV['DOCKER_IMAGE_TAG'], "GIT_REPO_URL":ENV['GIT_REPO_URL']}
  end

  config.trigger.before :destroy do |trigger|
    trigger.warn = "Unregister redhat developer account"
    trigger.run_remote = {inline: "sudo subscription-manager unregister"}
  end
end