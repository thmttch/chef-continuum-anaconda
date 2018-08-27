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

# If license is not accepted nothing at all is done
#  - No directory creation
#  - No package download
#  - No error generated
# This allow to include recipe and do nothing if the calling recipes does not want
# anaconda (or xant to delete it)
license_accepted = node.default[:anaconda][:accept_license] == "yes"

# This file is created at the end of installation process, so if an error
# occurs, installation restarts (which is not done if we only check if
# destination directory exists).
marker_file = "#{anaconda_install_dir}/.installed_by_chef_recipe"

remote_file installer_path do
  source installer_source
  checksum installer_checksum
  user node['anaconda']['owner']
  group node['anaconda']['group']
  mode 0755
  action :create_if_missing
  notifies :run, 'bash[run anaconda installer]', :delayed
  only_if {license_accepted}
end

directory node['anaconda']['install_root'] do
  owner node['anaconda']['owner']
  group node['anaconda']['group']
  recursive true
  only_if { license_accepted }
  action :nothing
end

bash 'run anaconda installer' do
  # Uses installer options not an input file which bahaviour is
  # somewhat random.
  # -b No license asked, so no anwser to give.
  # -u applies if a reinstall is asked. No effect if first install.
  code "bash #{installer_path} -b -p '#{anaconda_install_dir}' -u"
  user node['anaconda']['owner']
  group node['anaconda']['group']
  action :nothing
  only_if { license_accepted }
end

# Add system-wide path to profile.d
file '/etc/profile.d/anaconda.sh' do
  content "export PATH=$PATH:#{anaconda_install_dir}/bin"
  mode '0755'
  owner 'root'
  only_if { node['anaconda']['system_path'] }
  action :nothing
end

file marker_file do
    content "Do not modify or remove. This is a marker file for CHEF"
    user node['anaconda']['owner']
    group node['anaconda']['group']
    mode 0444
    notifies :create, "directory[#{node['anaconda']['install_root']}]", :before
    notifies :run, "bash[run anaconda installer]", :before
    notifies :create, "file[/etc/profile.d/anaconda.sh]", :before
    only_if {license_accepted}
end
