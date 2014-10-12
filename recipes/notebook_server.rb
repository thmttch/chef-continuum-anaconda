#
# Cookbook Name:: anaconda
# Recipe:: notebook_server
#
# Copyright (C) 2015 Matt Chu
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'runit::default'

anaconda_nbservice 'notebook-server' do
  # listen on all interfaces; there will be a warning since security is
  # disabled
  ip '*'
  port '8888'

  user 'vagrant'
  group 'vagrant'

  install_dir '/opt/ipython/server'

  service_action [ :enable, :start ]
end
