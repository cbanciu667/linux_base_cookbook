#
# Cookbook:: linux_base_cookbook
# Recipe:: debian_users
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'system'
include_recipe 'apt'
include_recipe 'chef-client'
include_recipe 'dynamic_motd'
include_recipe 'htpasswd'
include_recipe 'logrotate'
include_recipe 'rsync'

# add linux users
linux_users = data_bag('linux_users')
linux_users.each do |user|
  user = data_bag_item('linux_users', user)
  # create main user group
  group user['id'] do
    action :create
    gid user['uid']
    not_if { ::File.directory?("/home/#{user['id']}") }
  end
  user user['id'] do
    comment user['comment']
    action :create
    uid user['uid']
    gid user['uid']
    home "/home/#{user['id']}"
    manage_home true
    shell '/bin/bash'
    password user['password']
    not_if { ::File.directory?("/home/#{user['id']}") }
  end
  directory "/home/#{user['id']}" do
    owner user['id']
    group user['id']
    mode '0700'
    action :create
    not_if { ::File.directory?("/home/#{user['id']}") }
  end
  directory "/home/#{user['id']}/.ssh" do
    owner user['id']
    group user['id']
    mode '0700'
    action :create
    not_if { ::File.directory?("/home/#{user['id']}") }
  end
  template "/home/#{user['id']}/.ssh/authorized_keys" do
    source 'authorized_keys.erb'
    owner user['id']
    group user['id']
    mode '0600'
    variables ssh_keys: user['ssh_keys']
    not_if { ::File.directory?("/home/#{user['id']}") }
  end
end
# add existing users to sudo - check attributes
include_recipe 'sudo'
