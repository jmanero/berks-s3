# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.hostname = 'berks-s3'
  config.vm.box = 'ubuntu-14.04-provisionerless'
  config.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/'\
    'current/trusty-server-cloudimg-amd64-vagrant-disk1.box'

  # config.vm.provider :virtualbox do |vb|
    # vb.memory = 2048
  # end

  # config.vm.network :forwarded_port, :host => 9200, :guest => 9200

  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true
  config.berkshelf.berksfile_path = './cookbook/Berksfile'

  config.vm.provision :chef_solo do |chef|
    # chef.log_level = :debug
    chef.json = {
    }

    chef.run_list = [
      'recipe[berks-s3::default]'
    ]
  end
end
