This project aim to enable you to build multiarch with vagrant file

Technology used:
[Vagrant](https://www.vagrantup.com/)
[Virtual Box](https://www.virtualbox.org/)
[Docker Buildx](https://docs.docker.com/engine/reference/commandline/buildx/)
[qemu-user-static](https://github.com/multiarch/qemu-user-static)

Inspired by

1. https://mirailabs.io/blog/multiarch-docker-with-buildx/
2. https://nexus.eddiesinentropy.net/2020/01/12/Building-Multi-architecture-Docker-Images-With-Buildx/#Software-Requirements-for-Buildx-Non-Native-Architecture-Support
3. https://printhelloworld.de/posts/working-with-redhat-linux-in-vagrant/

Supported Platform based on [qemu-user-static](https://github.com/multiarch/qemu-user-static)

- linux/amd64, linux/arm64, linux/riscv64, linux/ppc64le, linux/s390x, linux/386, linux/arm/v7, linux/arm/v6

Check it out on https://github.com/DanielChuDC/multiarch-vagrant-rhel

### Prerequisite

1. REDHAT DEVELOPER ACCOUNT

   - If you encountered password error, probably your password has special character. In this case, you may want to change the password or using the activation key.
   - if you want to use activation key, can try this https://access.redhat.com/solutions/3341191 , https://access.redhat.com/articles/1378093

2. DOCKER HUB ACCOUNT
3. git
4. Vagrant

### Getting started with this project

1. Rename `example.env` to `.env` and modify `.env`
   - Add in the values
2. Install vagrant plugin for `.env` by run this command in terminal
   - `vagrant plugin install vagrant-env`
3. Provision server by `vagrant up`
