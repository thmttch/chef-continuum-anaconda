# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.hostname = 'anaconda-berkshelf'
  config.vm.box = 'precise32'
  config.vm.box_url = 'http://files.vagrantup.com/precise32.box'
  config.vm.network :private_network, ip: '33.33.33.123'

  # ssh
  config.ssh.forward_x11 = true
  config.ssh.forward_agent = true

  # plugins
  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  # provisioning

  # dev optimization: anaconda's big, so put it in the cache for development if
  # it's already been downloaded
  [
    'Anaconda-1.8.0-Linux-x86.sh',
    'Anaconda-1.8.0-Linux-x86_64.sh',
    'Anaconda-1.9.2-Linux-x86.sh',
    'Anaconda-1.9.2-Linux-x86_64.sh',
  ].each do |f|
    if File.exists?(f)
      config.vm.provision :shell do |shell|
        shell.inline = 'if [[ ! -f $1 ]]; then cp $1 $2; fi'
        shell.args = [ "/vagrant/#{f}",  '/var/chef/cache' ]
      end
    end
  end

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      :anaconda => {
        #:version => '1.9.2',
        #:flavor => 'x86',
        :accept_license => 'yes',
      }
    }

    chef.run_list = [
      #'recipe[anaconda::default]',
      #'recipe[anaconda::shell-conveniences]',
      'recipe[anaconda::package_tests]',
    ]
  end
end
