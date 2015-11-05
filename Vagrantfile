Vagrant.configure('2') do |config|
  config.vm.hostname = 'anaconda-berkshelf'
  # 14.04 LTS
  config.vm.box = 'ubuntu/trusty64'
  config.vm.network :private_network, ip: '33.33.33.123'

  # ssh
  config.ssh.forward_x11 = true
  config.ssh.forward_agent = true

  # plugins
  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  # vm tweaks
  config.vm.provider :virtualbox do |vb|
    #vb.memory = 1024
    #vb.cpus = 2
    # "no matter how much CPU is used in the VM, no more than 50% would be used on your own host machine"
    # http://docs.vagrantup.com/v2/virtualbox/configuration.html
    #vb.customize [ 'modifyvm', :id, '--cpuexecutioncap', '50' ]
  end

  # provisioning

  # dev optimization: anaconda installers are big, so put it in the guest's
  # chef cache if it's available on the host
  config.trigger.before :provision, :stdout => true do
    run_remote <<-SCRIPT
    VAGRANT_MOUNT=/vagrant/docker/container/installers

    for f in $(ls ${VAGRANT_MOUNT}); do
      echo "checking for ${f} in cache"
      if [[ ! -f /var/chef/cache/${f} ]]; then
        cp -v ${VAGRANT_MOUNT}/${f} /var/chef/cache
      else
        echo "${f} already in cache"
      fi
    done
    SCRIPT
  end

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      :anaconda => {
        :accept_license => 'yes',
      }
    }

    chef.run_list = [
      'recipe[anaconda::default]',
      'recipe[anaconda::shell_conveniences]',
      'recipe[anaconda::notebook_server]',
    ]

    chef.custom_config_path = 'vagrant-solo.rb'
    #chef.log_level = :debug
  end
end

# -*- mode: ruby -*-
# vi: set ft=ruby :
