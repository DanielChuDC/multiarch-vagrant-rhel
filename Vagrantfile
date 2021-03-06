# -*- mode: ruby -*-
# vi: set ft=ruby :

# options are documented and commented below. For a complete reference,
# please see the online documentation at vagrantup.com.

# Every Vagrant development environment requires a box. You can search for
# boxes at https://vagrantcloud.com/search.
VM_BOX  =  "generic/rhel8"

Vagrant.configure(2) do |config|
  config.env.enable # enable the plugin
  config.vm.box = VM_BOX
  config.ssh.extra_args = ["-t", "cd /home/vagrant; bash --login"] #https://stackoverflow.com/questions/17864047/automatically-chdir-to-vagrant-directory-upon-vagrant-ssh
  config.vagrant.plugins = "vagrant-env"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 4096 
    vb.cpus = 4
  end
  config.vm.provision 'shell' do |s| 
     s.path = 'provisioner.sh'
     s.env = { "RH_ACCOUNT_USERNAME"=>ENV['RH_ACCOUNT_USERNAME'], 
     "RH_ACCOUNT_PASSWORD"=>ENV['RH_ACCOUNT_PASSWORD'], 
     "ORG_ID"=>ENV['ORG_ID'], 
     "Key_NAME"=>ENV['Key_NAME'], 
     "DOCKER_HUB_USERNAME"=>ENV['DOCKER_HUB_USERNAME'], 
     "DOCKER_HUB_PASSWORD"=>ENV['DOCKER_HUB_PASSWORD'], 
     "DOCKER_IMAGE_NAME"=>ENV['DOCKER_IMAGE_NAME'], 
     "DOCKER_IMAGE_TAG"=>ENV['DOCKER_IMAGE_TAG'], 
     "GIT_REPO_URL"=>ENV['GIT_REPO_URL'],
     "GIT_BRANCH"=>ENV['GIT_BRANCH'],
     "TARGET_PLATFORM"=>ENV['TARGET_PLATFORM']}
  end

  config.trigger.before :destroy do |trigger|
    trigger.warn = "Unregister redhat developer account"
    trigger.run_remote = {
      inline: "
      if subscription-manager status; then 
      sudo subscription-manager unregister 
      fi
      "}
  end
end