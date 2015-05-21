#
# Cookbook Name:: anaconda
# Recipe:: python_workaround
#
# Copyright (C) 2015 Matt Chu
#
# All rights reserved - Do Not Redistribute
#

# https://github.com/thmttch/chef-continuum-anaconda/issues/12

# hack: the standard python cookbook gets confused and tries to upgrade
# setuptools since it can't find it (TODO actually, i think because it's not
# the latest version); this will break the chef run.
Chef::Log.warn 'Applying the python workaround: https://github.com/thmttch/chef-continuum-anaconda/issues/12'

chef_gem 'chef-rewind'
require 'chef/rewind'

unwind 'python_pip[setuptools]' do
  ignore_failure true
end
