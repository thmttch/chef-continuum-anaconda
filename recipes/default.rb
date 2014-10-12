#
# Cookbook Name:: anaconda
# Recipe:: default
#
# Copyright (C) 2015 Matt Chu
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt::default'

version = node.anaconda.version
flavor = node.anaconda.flavor

anaconda_install_dir = "#{node.anaconda.install_root}/#{version}"

installer =
  if 'miniconda-python2' == version
    "Miniconda-latest-Linux-#{flavor}.sh"
  elsif 'miniconda-python3' == version
    "Miniconda3-latest-Linux-#{flavor}.sh"
  else
    "Anaconda-#{version}-Linux-#{flavor}.sh"
  end
Chef::Log.debug "installer = #{installer}"

installer_path = "#{Chef::Config[:file_cache_path]}/#{installer}"
installer_source = "#{node.anaconda.installer[version]['uri_prefix']}/#{installer}"
installer_checksum = node.anaconda.installer[version][flavor]

installer_config = 'installer_config'
installer_config_path = "#{Chef::Config[:file_cache_path]}/#{installer_config}"

remote_file installer_path do
  source installer_source
  checksum installer_checksum
  user node.anaconda.owner
  group node.anaconda.group
  mode 0755
  action :create_if_missing
  notifies :run, 'bash[run anaconda installer]', :delayed
end

template installer_config_path do
  source "#{installer_config}.erb"
  user node.anaconda.owner
  group node.anaconda.group
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
