#
# Cookbook Name:: anaconda
# Recipe:: shell-conveniences
#
# Copyright (C) 2014 Matt Chu
#
# All rights reserved - Do Not Redistribute
#

template "#{node.anaconda.home}/source-me.sh" do
  source 'source-me.sh.erb'
  variables({
    :install_root => node.anaconda.install_root,
    :version => node.anaconda.version,
  })
end

