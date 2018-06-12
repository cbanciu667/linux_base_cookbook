# Cookbook:: linux_base_cookbook
# Recipe:: debian_services_config
#
# Copyright:: 2018, Cosmin Banciu, All Rights Reserved.

# vsftpd section
template '/etc/vsftpd.conf' do
  source 'vsftpd.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[vsftpd]', :delayed
end
service 'vsftpd'

# squid section
template '/etc/squid/squid.conf' do
  source 'squid.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[squid]', :delayed
end
service 'squid'

# samba section
directory '/mnt/data' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template '/etc/samba/smb.conf' do
  source 'smb.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[smbd]', :delayed
  notifies :restart, 'service[nmbd]', :delayed
end
service 'smbd'
service 'nmbd'

# logrotate section
logrotate_app 'chef-client-log' do
  path      '/var/log/chef/client.log'
  frequency 'daily'
  rotate    30
  create    '644 root adm'
end
logrotate_app 'ssh-failed-log' do
  path      '/home/user/failed_ssh_logins.log'
  frequency 'weekly'
  rotate    30
  create    '644 root adm'
end
logrotate_app 'opevpn-log' do
  path      '/var/log/openvpn.log'
  frequency 'weekly'
  rotate    30
  create    '644 root adm'
end
