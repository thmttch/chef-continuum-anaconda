#
# Cookbook Name:: anaconda
# Recipe:: package_tests
#
# Copyright (C) 2015 Matt Chu
#
# All rights reserved - Do Not Redistribute
#

log 'do NOT include this in your runlist! for testing only.' do
  level :error
end

anaconda_package 'astroid' do
  action :install
end

anaconda_package 'astroid' do
  action :remove
end
