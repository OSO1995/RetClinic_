Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.provision :shell, path: "init.sh"
  config.vm.network :forwarded_port, host: 8081, guest: 8081
  config.vm.network :forwarded_port, host: 8090, guest: 8090
end