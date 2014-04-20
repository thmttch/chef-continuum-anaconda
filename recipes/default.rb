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
Chef::Log.debug "installer = #{installer}"
debconf_template = "anaconda-debconf"
debconf_template_path = "#{Chef::Config[:file_cache_path]}/#{debconf_template}"

remote_file "#{Chef::Config[:file_cache_path]}/#{installer}" do
  source "http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/#{installer}"
  checksum node.anaconda.installer[version][flavor]
  notifies :run, 'bash[run anaconda installer]', :delayed
end

#template "#{Chef::Config[:file_cache_path]}/#{installer}.debconf" do
template debconf_template_path do
  source "#{debconf_template}.erb"
  #owner
  #group
  #mode
  variables({
    :version => version,
    :flavor => flavor,
    :anaconda_install_dir => anaconda_install_dir,
    :add_to_shell_path => add_to_shell_path ? 'yes' : 'no',
  })
end

bash 'run anaconda installer' do
  code "cat #{debconf_template_path} | bash #{Chef::Config[:file_cache_path]}/#{installer}"
  #action :run
  action :nothing
  not_if { File.directory?(anaconda_install_dir) }
end
