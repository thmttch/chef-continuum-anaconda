# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "chef-continuum-anaconda-berkshelf"
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.network :private_network, ip: "33.33.33.10"

  # ssh
  config.ssh.forward_x11 = true
  config.ssh.forward_agent = true
  #config.ssh.max_tries = 40
  #config.ssh.timeout   = 120

  # plugins
  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  # provisioning

  # anaconda's big, so put it in the cache for development
  if File.exists?('Anaconda-1.8.0-Linux-x86.sh')
    #config.trigger.before [ :provision ], :execute => "bash -c 'cp /vagrant/Anaconda-1.8.0-Linux-x86.sh /var/chef/cache'", :stdout => true
    config.vm.provision :shell do |shell|
      shell.inline = "if [[ ! -f $1 ]]; then cp $1 $2; fi"
      shell.args = %q{/vagrant/Anaconda-1.8.0-Linux-x86.sh /var/chef/cache}
    end
  end

  config.vm.provision :chef_solo do |chef|
    chef.json = {
    }

    chef.run_list = [
        "recipe[chef-continuum-anaconda::default]"
    ]
  end
end
