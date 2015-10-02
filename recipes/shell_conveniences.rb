#
# Cookbook Name:: anaconda
# Recipe:: shell-conveniences
#
# Copyright (C) 2015 Matt Chu
#
# All rights reserved - Do Not Redistribute
#

template '/etc/profile.d/anaconda-env.sh' do
  source 'source-me.sh.erb'
  variables({
    :install_root => node.anaconda.install_root,
    :version => node.anaconda.version,
  })
end
