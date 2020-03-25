Vagrant.configure("2") do |config|
  # Box name and select version
  config.vm.box = "centos/8"
  config.vm.box_version = "1905.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

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
