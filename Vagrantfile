Dotenv.load
Vagrant.configure('2') do |config|

  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    override.vm.box = 'digital_ocean'
    override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"

    provider.token = ENV['DG_TOKEN']
    provider.image = 'ubuntu-14-04-x64'
    provider.region = 'sgp1'
    provider.size = '512mb'
  end
    config.vm.provision "shell", path: "deploy.sh"
end
