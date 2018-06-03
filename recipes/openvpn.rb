# Cookbook:: cos_linux_base
# Recipe:: debian_openvpn
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
    echo tls-auth #{node['openvpn']['key_dir']}/ta.key 0 >> /etc/openvpn/server.conf
    echo key-direction 0 >> /etc/openvpn/server.conf
  EOH
  not_if { ::File.exist?("#{node['openvpn']['key_dir']}/ta.key") }
  notifies :restart, 'service[openvpn]'
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

service 'openvpn' do
  action :restart
end
=begin
# openvpn users
OPENVPN_USERS_DATABAG = 'myserver_vpn_users'

begin
  search(OPENVPN_USERS_DATABAG, 'enabled:true') do |u|
    execute "generate-openvpn-#{u['id']}" do
      command "./pkitool #{u['id']}"
      cwd "/etc/openvpn/easy-rsa"
      environment(
        'EASY_RSA' => '/etc/openvpn/easy-rsa',
        'KEY_CONFIG' => '/etc/openvpn/easy-rsa/openssl.cnf',
        'KEY_DIR' => node["openvpn"]["key_dir"],
        'CA_EXPIRE' => node["openvpn"]["key"]["ca_expire"].to_s,
        'KEY_EXPIRE' => node["openvpn"]["key"]["expire"].to_s,
        'KEY_SIZE' => node["openvpn"]["key"]["size"].to_s,
        'KEY_COUNTRY' => node["openvpn"]["key"]["country"],
        'KEY_PROVINCE' => node["openvpn"]["key"]["province"],
        'KEY_CITY' => node["openvpn"]["key"]["city"],
        'KEY_ORG' => node["openvpn"]["key"]["org"],
        'KEY_EMAIL' => node["openvpn"]["key"]["email"]
      )
      not_if { ::File.exists?("#{node["openvpn"]["key_dir"]}/#{u['id']}.crt") }
    end

    %w(conf ovpn).each do |ext|
      template "#{node["openvpn"]["key_dir"]}/#{u['id']}.#{ext}" do
        cookbook "openvpn"
        source "client.conf.erb"
        variables :username => u['id']
      end
    end

    execute "create-openvpn-tar-#{u['id']}" do
      cwd node['openvpn']['key_dir']
      command <<-EOH
        tar zcf #{u['id']}.tar.gz ca.crt ta.key #{u['id']}.crt #{u['id']}.key #{u['id']}.conf #{u['id']}.ovpn
      EOH
      not_if { ::File.exist?("#{node["openvpn"]["key_dir"]}/#{u['id']}.tar.gz") }
    end
  end
rescue Net::HTTPServerException => e
  Chef::Log.warn("Unable to retrieve openvpn users from the data bag #{OPENVPN_USERS_DATABAG}: " + e.response.code)
end
=end
