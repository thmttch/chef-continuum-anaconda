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

# figure out permissions to install here? maybe it's readonly and doesn't matter
anaconda_install_dir = '/opt/anaconda'
add_to_shell_path = true

installer = 'Anaconda-1.8.0-Linux-x86.sh'

# TODO autodetect 64-bit versus 32
#remote_file "#{Chef::Config[:file_cache_path]}/Anaconda-1.8.0-Linux-x86_64.sh" do
  #source 'http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/Anaconda-1.8.0-Linux-x86_64.sh'
  #checksum '44da25d5fec8a1acc26bad816c928e002d877334'
#end
# ~ 393 mb
remote_file "#{Chef::Config[:file_cache_path]}/#{installer}" do
  source "http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/#{installer}"
  checksum '9eeda2307e9f5c7927ce610fc9dcd632c3d42fab'
end

bash 'run installer' do
  # yes, this is nested heredocs; see below for conversation
  code <<EOS
bash "#{Chef::Config[:file_cache_path]}/#{installer}" <<STDIN

yes
#{anaconda_install_dir}
#{add_to_shell_path ? 'yes' : 'no'}
STDIN
EOS
  not_if { File.exists?(anaconda_install_dir) }
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

# TODO 1.9.2
# linux 32-bit, 411m
# http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/Anaconda-1.9.2-Linux-x86.sh
# linux 64-bit, 483m
# http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/Anaconda-1.9.2-Linux-x86_64.sh
