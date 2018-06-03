#
# Cookbook:: cos_linux_base
# Recipe:: debian_users
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'system'
include_recipe 'apt'
include_recipe 'chef-client'
include_recipe 'dynamic_motd'
include_recipe 'logrotate'
include_recipe 'poise-python'
include_recipe 'rsync'

# add linux users
linux_users = data_bag('linux_users')
linux_users.each do |user|
  user = data_bag_item('linux_users', user)
  # create main user group
  group user['id'] do
    action :create
    gid user['uid']
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
  end
  directory "/home/#{user['id']}" do
    owner user['id']
    group user['id']
    mode '0700'
    action :create
  end
  directory "/home/#{user['id']}/.ssh" do
    owner user['id']
    group user['id']
    mode '0700'
    action :create
  end
  template "/home/#{user['id']}/.ssh/authorized_keys" do
    source 'authorized_keys.erb'
    owner user['id']
    group user['id']
    mode '0600'
    variables ssh_keys: user['ssh_keys']
  end
end
# add existing users to sudo - check attributes
include_recipe 'sudo'
