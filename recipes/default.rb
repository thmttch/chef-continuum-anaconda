#
# Cookbook Name:: anaconda
# Recipe:: default
#
# Copyright (C) 2014 Matt Chu
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt::default'
include_recipe 'python::default'

version = node.anaconda.version
flavor = node.anaconda.flavor

anaconda_install_dir = "#{node.anaconda.install_root}/#{version}"
installer = "Anaconda-#{version}-Linux-#{flavor}.sh"
installer_path = "#{Chef::Config[:file_cach_path]}/#{installer}"
installer_config = 'installer_config'
installer_config_path = "#{Chef::Config[:file_cache_path]}/#{installer_config}"

Chef::Log.debug "installer = #{installer}"

remote_file installer_path do
  source "http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/#{installer}"
  checksum node.anaconda.installer[version][flavor]
  notifies :run, 'bash[run anaconda installer]', :delayed
end

template installer_config_path do
  source "#{installer_config}.erb"
  variables({
    :version => version,
    :flavor => flavor,
    :anaconda_install_dir => anaconda_install_dir,
    :accept_license => node.anaconda.accept_license,
    :add_to_shell_path => 'no',
  })
end

directory node.anaconda.install_root do
  owner node.anaconda.owner
  group node.anaconda.group
  recursive true
end

bash 'run anaconda installer' do
  code "cat #{installer_config_path} | bash #{installer_path}"
  user node.anaconda.owner
  group node.anaconda.group
  action :run
  not_if { File.directory?(anaconda_install_dir) }
end
