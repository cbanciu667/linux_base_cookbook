
#### Packages and services
default['install_java'] = true
default['install_nodejs'] = false
default['install_nginx'] = false
default['install_php'] = false
default['install_docker'] = false
default['install_aws_tools'] = false

#### Sudo
force_override['authorization']['sudo']['groups'] = %w(sysadmin root)
force_override['authorization']['sudo']['users'] = %w(USER1 USER2)
force_override['authorization']['sudo']['passwordless'] = true
force_override['authorization']['sudo']['setenv'] = true
force_override['authorization']['sudo']['include_sudoers_d'] = false

#### chef-client
override['chef-client']['interval'] = '7200'
override['chef_client']['log_file'] = '/var/log/chef/chef-client.log'
override['chef_client']['cron']['log_file'] = '/var/log/chef/chef-client.log'

#### ntp
override["ntp"]["servers"] = [ "0.pool.ntp.org", "1.pool.ntp.org" ]

#### motd
force_override['dynamic_motd']['message'] = 'My server, by cos667'

# test if ec2 instance or not
if defined? node['ec2']['service_domain']
    default['ec2_with_iam_role'] = true
else
    default['ec2_with_iam_role'] = false
end

#### system
node_name = node.name
override['system']['timezone'] = 'Europe/Bucharest'
override['system']['upgrade_packages'] = true
override['apt']['compile_time_update'] = true
override['route_53']['zone_id'] = 'ZONE_ID'
override['system']['short_hostname'] = node_name.split('.')[0]
override['system']['domain_name'] = node_name.partition('.').last
override['system']['static_hosts'] = { "#{node['ipaddress']}" => node.name,
    '8.8.8.8' => 'dns-1.google.com' }

# Don't allow overriding java version
force_override['java']['jdk_version'] = '8'
force_override['java']['install_flavor'] = 'openjdk'
force_override['java']['set_default'] = true

#### ELK stack
override['elk']['elasticsearch']['host'] = 'localhost'

#### Cloudwatch
override['aws_cwlogs']['region'] = 'eu-central-1'
override['aws_cwlogs']['log']['syslog'] = {
 'datetime_format' => '%b %d %H:%M:%S',
 'file' => '/var/log/syslog',
 'buffer_duration' => '5000',
 'log_stream_name' => node.name,
 'initial_position' => 'start_of_file',
 'log_group_name' => '/var/log/syslog'
}
override['aws_cwlogs']['log']['messages'] = {
 'datetime_format' => '%b %d %H:%M:%S',
 'file' => '/var/log/messages',
 'buffer_duration' => '5000',
 'log_stream_name' => node.name,
 'initial_position' => 'start_of_file',
 'log_group_name' => '/var/log/messages'
}
override['aws_cwlogs']['log']['dpkg'] = {
 'datetime_format' => '%b %d %H:%M:%S',
 'file' => '/var/log/dpkg.log',
 'buffer_duration' => '5000',
 'log_stream_name' => node.name,
 'initial_position' => 'start_of_file',
 'log_group_name' => '/var/log/dpkg.log'
}
override['aws_cwlogs']['log']['auth'] = {
 'datetime_format' => '%b %d %H:%M:%S',
 'file' => '/var/log/auth.log',
 'buffer_duration' => '5000',
 'log_stream_name' => node.name,
 'initial_position' => 'start_of_file',
 'log_group_name' => '/var/log/auth.log'
}
override['aws_cwlogs']['log']['openvpn'] = {
 'datetime_format' => '%b %d %H:%M:%S',
 'file' => '/var/log/openvpn.log',
 'buffer_duration' => '5000',
 'log_stream_name' => node.name,
 'initial_position' => 'start_of_file',
 'log_group_name' => '/var/log/openvpn.log'
}
