# Cookbook:: linux_base_cookbook
# Recipe:: debian_elk
#
# Copyright:: 2018, Cosmin Banciu, All Rights Reserved.

# add elasticsearch repo
apt_repository 'elastic_repository' do
  uri 'https://artifacts.elastic.co/packages/5.x/apt'
  components ['stable', 'main']
  distribution ''
  key 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
  action :add
end


# install required packages for ELK
apt_update 'update'

['elasticsearch', 'kibana', 'nginx', 'apache2-utils', 'logstash', 'apt-transport-https', 'filebeat'].each do |package|
  apt_package package do
    action :install
  end
end


# configure elasticsearch
template '/etc/elasticsearch/elasticsearch.yml' do
  source 'elk/elasticsearch.erb'
  variables elasticsearch_host: node['elk']['elasticsearch']['host']
  notifies :restart, 'service[elasticsearch]', :delayed
end

service 'elasticsearch' do
  action :enable
end

service 'elasticsearch'

# configure kibana and nginx
template '/etc/kibana/kibana.yml' do
  source 'elk/kibana.erb'
  notifies :restart, 'service[kibana]', :delayed
end

service 'kibana' do
  action :enable
end

service 'kibana'

template '/etc/nginx/sites-available/kibana' do
  source 'elk/nginx_kibana.erb'
  variables host_fqdn: node['host_fqdn']
end

chef_gem 'htauth' # fix for https://github.com/redguide/htpasswd/issues/31
kibana_users = data_bag('kibana_users')
kibana_users.each do |user|
  user = data_bag_item('kibana_users', user)
  htpasswd '/etc/nginx/.kibana-user' do
    user user['id']
    password user['password']
  end
end

file '/etc/nginx/sites-enabled/default' do
  action :delete
end

link '/etc/nginx/sites-enabled/kibana' do
  to '/etc/nginx/sites-available/kibana'
  notifies :restart, 'service[nginx]', :delayed
end

service 'nginx' do
  action :enable
end

service 'nginx'


# configure logstash
template '/etc/logstash/conf.d/filebeat-input.conf' do
  source 'elk/filebeat-input.erb'
end

template '/etc/logstash/conf.d/syslog-filter.conf' do
  source 'elk/syslog-filter.erb'
end

template '/etc/logstash/conf.d/output-elasticsearch.conf' do
  source 'elk/output-elasticsearch.erb'
end

bash 'generate logstash certificates' do
  cwd '/etc/logstash/'
  code <<-EOH
  openssl req -subj /CN=#{node['host_fqdn']} -x509 -days 3650 -batch -nodes -newkey rsa:4096 -keyout logstash.key -out logstash.crt
  chmod 0744 logstash.key && chmod 0744 logstash.crt
  EOH
  not_if { ::File.exist?('/etc/logstash/logstash.crt') }
  notifies :restart, 'service[logstash]'
end

service 'logstash' do
  action :enable
end

service 'logstash'


# configure filebeat
template '/etc/filebeat/filebeat.yml' do
  source 'elk/filebeat.erb'
  notifies :restart, 'service[filebeat]'
end

service 'filebeat' do
  action :enable
end

service 'filebeat'


# ELK metricbeat
execute 'download_metricbeat' do
  command 'curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-6.2.4-amd64.deb'
  not_if { ::File.exist?('/usr/bin/metricbeat') }
end

dpkg_package 'install_metricbeat' do
  action :install
  source './metricbeat-6.2.4-amd64.deb'
  not_if { ::File.exist?('/usr/bin/metricbeat') }
end

template '/etc/metricbeat/metricbeat.yml' do
  source 'elk/metricbeat.erb'
  notifies :restart, 'service[metricbeat]'
end

service 'metricbeat' do
  action :enable
end

service 'metricbeat'

# must be ran manuallly :( - not automated as i have no method to test if deployed
# execute 'install_metricbeat_kibana_dashboards' do
#  command 'metricbeat setup --dashboards'
# end


# ELK curator
execute 'install_elk_curator' do
  command 'pip install elasticsearch-curator'
  not_if { ::File.exist?('/usr/local/bin/curator') }
end

directory '/etc/curator' do
  action :create
end

template '/etc/curator/Action-File.yml' do
  source 'elk/Action-File.erb'
end

template '/etc/curator/Curator-Config.yml' do
  source 'elk/Curator-Config.erb'
end
