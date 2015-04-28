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
  ip node.anaconda.notebook.ip
  port node.anaconda.notebook.port

  owner node.anaconda.notebook.owner
  group node.anaconda.notebook.group

  install_dir node.anaconda.notebook.install_dir

  service_action [ :enable, :start ]
end
