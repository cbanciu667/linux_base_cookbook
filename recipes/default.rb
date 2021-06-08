# Cookbook:: linux_base_cookbook
# Recipe:: default
#
# Copyright:: 2018, Cosmin Banciu, All Rights Reserved.

case node['platform']
when 'ubuntu'
  include_recipe 'linux_base_cookbook::users'
  include_recipe 'linux_base_cookbook::packages'
  include_recipe 'linux_base_cookbook::services_config'
  include_recipe 'linux_base_cookbook::aws'
else
  Chef::Log.debug('Cookbook works only on Linux Ubuntu')
  Chef::Log.info('Cookbook works only on Linux Ubuntu')
end
