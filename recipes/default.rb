# Cookbook:: cos_linux_base
# Recipe:: default
#
# Copyright:: 2018, Cosmin Banciu, All Rights Reserved.

case node['platform_family']
when 'debian'
  include_recipe 'cos_linux_base::debian_users'
  include_recipe 'cos_linux_base::debian_packages'
  include_recipe 'cos_linux_base::debian_services_config'
  include_recipe 'cos_linux_base::aws'
  if node['install_openvpn'] == true
    include_recipe 'cos_linux_base::openvpn'
  end
  if node['install_elk'] == true
    include_recipe 'cos_linux_base::debian_elk'
  end
when 'centos'
  include_recipe 'cos_linux_base::centos_users'
  include_recipe 'cos_linux_base::centos_packages'
  include_recipe 'cos_linux_base::centos_services_config'
  include_recipe 'cos_linux_base::aws'
  if node['install_openvpn'] == true
    include_recipe 'cos_linux_base::openvpn'
  end
  if node['install_elk'] == true
    include_recipe 'cos_linux_base::centos_elk'
  end
else
  Chef::Log.debug('Cookbook built only for Linux Debian or Centos')
  Chef::Log.info('Cookbook built only for Linux Debian or Centos')
end
