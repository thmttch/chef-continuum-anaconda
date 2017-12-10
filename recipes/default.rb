#
# Cookbook Name:: anaconda
# Recipe:: default
#
# Copyright (C) 2015 Matt Chu
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt::default'
# ubuntu: base docker images don't have bzip installed, which the anaconda
# installer needs
include_recipe 'bzip2::default'
# centos: base docker images don't have tar (?!?)
include_recipe 'tar::default'

# make sure the desired user and group exists
group node['anaconda']['group']
user node['anaconda']['owner'] do
  gid node['anaconda']['group']
  home node['anaconda']['home']
  manage_home true
end

version = node['anaconda']['version']
python_version = node['anaconda']['python']
flavor = node['anaconda']['flavor'] || (
  case node['kernel']['machine']
  when 'i386', 'i686'
    'x86'
  when 'x86_64'
    'x86_64'
  else
    Chef::Log.fatal("Unrecognized node['kernel']['machine']=#{node['kernel']['machine']}; please explicitly node['anaconda']['flavor']")
  end
)
Chef::Log.debug "Autodetected node['kernel']['machine']=#{node['kernel']['machine']}, implying flavor=#{flavor}"
install_type = node['anaconda']['install_type']
installer_info = node['anaconda']['installer_info'][install_type][version][python_version]

# e.g.
# Anaconda-5.0.1-Linux-x86
# Anaconda3-5.0.1-Linux-x86
# Miniconda-latest-Linux-x86
# Miniconda3-latest-Linux-x86
installer_basename =
  if install_type == 'anaconda'
    "Anaconda#{python_version == 'python3' ? '3' : (Gem::Version.new(version) >= Gem::Version.new('4.0.0') ? '2' : '')}-#{version}-Linux-#{flavor}.sh"
  else
    Chef::Log.debug "miniconda installs ONLY have version = latest; setting it now"
    node.default['anaconda']['version'] = 'latest'
    version = 'latest'
    "Miniconda#{python_version == 'python3' ? '3' : '2'}-#{version}-Linux-#{flavor}.sh"
  end
Chef::Log.debug "installer_basename = #{installer_basename}"

# where the installer will install to
anaconda_install_dir = "#{node['anaconda']['install_root']}/#{version}"
# where the installer is downloaded to locally
installer_path = "#{Chef::Config[:file_cache_path]}/#{installer_basename}"
# where to download the installer from
installer_source = "#{installer_info['uri_prefix']}/#{installer_basename}"
installer_checksum = installer_info[flavor]

installer_config = 'installer_config'
installer_config_path = "#{Chef::Config[:file_cache_path]}/#{installer_config}"

remote_file installer_path do
  source installer_source
  checksum installer_checksum
  user node['anaconda']['owner']
  group node['anaconda']['group']
  mode 0755
  action :create_if_missing
  notifies :run, 'bash[run anaconda installer]', :delayed
end

template installer_config_path do
  source "#{installer_config}.erb"
  user node['anaconda']['owner']
  group node['anaconda']['group']
  variables({
    :version => version,
    :flavor => flavor,
    :anaconda_install_dir => anaconda_install_dir,
    :accept_license => node['anaconda']['accept_license'],
    :add_to_shell_path => 'no',
  })
end

directory node['anaconda']['install_root'] do
  owner node['anaconda']['owner']
  group node['anaconda']['group']
  recursive true
end

bash 'run anaconda installer' do
  code "cat #{installer_config_path} | bash #{installer_path}"
  user node['anaconda']['owner']
  group node['anaconda']['group']
  action :run
  not_if { File.directory?(anaconda_install_dir) }
end

# Add system-wide path to profile.d
file '/etc/profile.d/anaconda.sh' do
  content "export PATH=$PATH:#{anaconda_install_dir}/bin"
  mode '0755'
  owner 'root'
  only_if { node['anaconda']['system_path'] }
end
