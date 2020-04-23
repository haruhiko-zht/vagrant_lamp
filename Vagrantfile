Vagrant.configure("2") do |config|
  # Box name
  config.vm.box = "centos/8"

  # Select version and check update
  # config.vm.box_version = "1905.1"
  # config.vm.box_check_update = false

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # Sync folder
  # See document about sync-type
  # (maybe required vagrant plugin "vagrant-vbguest")
  # config.vm.synced_folder "./host", "/guest", type: "virtualbox", disabled: false
  # config.vm.synced_folder ".", "/vagrant", disabled: true

  # Box spec
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # Customize the amount of cpu on the VM:
    vb.cpus = "2"

    # Customize the amount of memory on the VM:
    vb.memory = "2048"
  end

  # First 'Vagrant up'
  config.vm.provision :shell, :path => "provision/provision.sh"

end
