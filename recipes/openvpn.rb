# Cookbook:: linux_base_cookbook
# Recipe:: openvpn
#
# Copyright:: 2018, Cosmin Banciu, All Rights Reserved.

include_recipe 'openvpn::server'
include_recipe 'openvpn::easy_rsa'

directory "#{node['openvpn']['key_dir']}" do
  owner 'root'
  group 'root'
  mode 0644
  action :create
end

# generate ta.key
bash 'generate ta key' do
  user 'root'
  cwd '/root/'
  code <<-EOH
    openvpn --genkey --secret #{node['openvpn']['key_dir']}/ta.key
  EOH
  not_if { ::File.exist?("#{node['openvpn']['key_dir']}/ta.key") }
end

# openvpn log logrotate setup
if node['openvpn']['config'].attribute?('log') && node['openvpn']['config']['log'] != ''
  template '/etc/logrotate.d/openvpn' do
    action :create
    owner 'root'
    group 'root'
    mode 0644
    source 'logrotate_openvpn.erb'
  end
end

include_recipe 'openvpn::users'
