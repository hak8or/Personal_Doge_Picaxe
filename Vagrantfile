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
  
  config.vm.provider "virtualbox" do |v|
    # Memory is default at 490MB, p2p miner can require more if lots of
    # mining is going on, so lets bump it up to 576 MB. Some gets reserved.
    v.memory = 600
  end

  # Script to setup the node.
  config.vm.provision "shell", path: "setup.rb", :privileged => false
  
  # Use squid's cache proxy to prevent me from hammering Canoical's servers
  # and dogechain's CDN for bootstrap.dat when developing if the plugin is
  # installed.
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://squid:squid@10.0.0.10:3128"
    config.proxy.https    = "http://squid:squid@10.0.0.10:3128"
    config.apt_proxy.http  = "http://squid:squid@10.0.0.10:3128"
    config.proxy.no_proxy = "localhost,127.0.0.1,.example.com"
  end
end
