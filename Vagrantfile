# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Port 22550 used to see the current status of the p2p pool node.
  config.vm.network :forwarded_port, guest: 22550, host: 22550

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu_13-10-dev"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/saucy/current/saucy-server-cloudimg-amd64-vagrant-disk1.box"

  # Disables the default shared folder vagrant does.
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Script to setup the node.
  config.vm.provision "shell", path: "provision.sh"
end
