# Cookbook:: linux_base_cookbook
# Recipe:: default
#
# Copyright:: 2018, Cosmin Banciu, All Rights Reserved.

case node['platform_family']
when 'debian'
  include_recipe 'linux_base_cookbook::debian_users'
  include_recipe 'linux_base_cookbook::debian_packages'
  include_recipe 'linux_base_cookbook::debian_services_config'
  include_recipe 'linux_base_cookbook::aws'
  if node['install_openvpn'] == true
    include_recipe 'linux_base_cookbook::debian_openvpn'
  end
  if node['install_elk'] == true
    include_recipe 'linux_base_cookbook::debian_elk'
  end
when 'centos'
  include_recipe 'linux_base_cookbook::centos_users'
  include_recipe 'linux_base_cookbook::centos_packages'
  include_recipe 'linux_base_cookbook::centos_services_config'
  include_recipe 'linux_base_cookbook::aws'
  if node['install_openvpn'] == true
    include_recipe 'linux_base_cookbook::centos_openvpn'
  end
  if node['install_elk'] == true
    include_recipe 'linux_base_cookbook::centos_elk'
  end
else
  Chef::Log.debug('Cookbook built only for Linux Debian or Centos')
  Chef::Log.info('Cookbook built only for Linux Debian or Centos')
end
