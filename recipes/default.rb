#
# Cookbook Name:: chef-continuum-anaconda
# Recipe:: default
#
# Copyright (C) 2014 Matt Chu
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt::default'
include_recipe 'python::default'

anaconda_install_dir = node.anaconda.install_root
add_to_shell_path = node.anaconda.add_to_shell_path
version = node.anaconda.version
flavor = node.anaconda.flavor
installer = "Anaconda-#{version}-Linux-#{flavor}.sh"
puts installer

remote_file "#{Chef::Config[:file_cache_path]}/#{installer}" do
  source "http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/#{installer}"
  checksum node.anaconda.installer[version][flavor]
  #notifies :run, 'bash[run anaconda installer]', :delayed
end

bash 'run anaconda installer' do
  # yes, this is nested heredocs; see below for conversation
  code <<EOS
bash "#{Chef::Config[:file_cache_path]}/#{installer}" <<STDIN

yes
#{anaconda_install_dir}
#{add_to_shell_path ? 'yes' : 'no'}
STDIN
EOS
  action :run
  not_if { File.directory?(anaconda_install_dir) }
end

=begin
The questions are:
# In order to continue the installation process, please review the license
# agreement.  Please, press ENTER to continue
'',
# Do you approve the license terms? [yes|no]
'yes',
# Anaconda will now be installed into this location:
# /home/blah/anaconda
#  - Press ENTER to confirm the location
#  - Press CTRL-C to abort the installation
#  - Or specify an different location below
anaconda_install_dir,
# Do you wish the installer to prepend the Anaconda install location to PATH in your /home/vagrant/.bashrc ? [yes|no]
add_to_shell_path ? 'yes' : 'no'
=end
