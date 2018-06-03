
#### Packages and services
default['install_openvpn'] = true
default['install_elk'] = false
default['install_java'] = true
default['install_nodejs'] = false
default['install_nginx'] = false
default['install_php'] = false
default['install_docker'] = false
default['install_aws_tools'] = false

#### Sudo
force_override['authorization']['sudo']['groups'] = %w(sysadmin root)
force_override['authorization']['sudo']['users'] = %w(user1 user2)
force_override['authorization']['sudo']['passwordless'] = true
force_override['authorization']['sudo']['setenv'] = true
force_override['authorization']['sudo']['include_sudoers_d'] = false

#### chef-client
override['chef-client']['interval'] = '1600'

#### ntp
override["ntp"]["servers"] = [ "0.pool.ntp.org", "1.pool.ntp.org" ]

#### motd
force_override['dynamic_motd']['message'] = 'myserver server, by cos667'

#### system
override['system']['timezone'] = 'Europe/Bucharest'
override['system']['short_hostname'] = 'node01'
override['system']['domain_name'] = 'mydomain.net'
override['system']['upgrade_packages'] = true
override['apt']['compile_time_update'] = true

# Don't allow overriding java version
force_override['java']['jdk_version'] = '8'
force_override['java']['install_flavor'] = 'openjdk'
force_override['java']['set_default'] = true

# OpenVPN server
override['openvpn']['configure_default_server'] = true # set to false if all configs made with LWPR
override['openvpn']['config']['local'] = 'node01.mydomain.net'
override['openvpn']['config']['dev'] = 'tun'
override['openvpn']['config']['proto'] = 'udp'
override['openvpn']['config']['port'] = '1194'
override['openvpn']['config']['keepalive'] = '10 120'
override['openvpn']['config']['log'] = '/var/log/openvpn.log'
override['openvpn']['config']['comp-lzo'] = ''
override['openvpn']['config']['ca'] = node['openvpn']['signing_ca_cert']
override['openvpn']['config']['key'] = "#{node['openvpn']['key_dir']}/server.key"
override['openvpn']['config']['cert'] = "#{node['openvpn']['key_dir']}/server.crt"
override['openvpn']['config']['dh'] = "#{node['openvpn']['key_dir']}/dh#{node['openvpn']['key']['size']}.pem"
override['openvpn']['config']['server'] = "#{node['openvpn']['subnet']} #{node['openvpn']['netmask']}"
override['openvpn']['config']['up'] = '/etc/openvpn/server.up.sh'
override['openvpn']['config']['ifconfig-pool-persist'] = 'ipp.txt'
override['openvpn']['config']['client-to-client'] = ''
override['openvpn']['config']['auth'] = 'SHA256'
override['openvpn']['config']['cipher'] = 'AES-256-CBC'
override['openvpn']['config']['verb'] = 4
override['openvpn']['type'] = 'server'
override['openvpn']['proto'] = 'udp'
override['openvpn']['port'] = '1194'
override['openvpn']['gateway'] = 'node01.mydomain.net'
override['openvpn']['subnet'] = '10.8.7.0'
override['openvpn']['netmask'] = '255.255.255.0'
override['openvpn']['key']['country'] = 'RO'
override['openvpn']['key']['province'] = 'BV'
override['openvpn']['key']['city'] = 'Brasov'
override['openvpn']['key']['org'] = 'myserver'
override['openvpn']['key']['email'] = "cb2375@outlook.com"
override['openvpn']['key']['size'] = 2048
override['openvpn']['script-security'] = 2
override['openvpn']['user_databag'] = 'myserver_vpn_users'
override['openvpn']['enable_peers'] = false
# override['openvpn']['push_routes'] = ["192.168.100.0 255.255.255.0"]
# node.default['openvpn']['routes'] = ['172.31.0.0 255.255.240.0']
# override['openvpn']['push_options'] = ["dhcp-option",
# ["DNS 8.8.8.8", "DOMAIN domain.local", "DOMAIN-SEARCH domain.local"]]
default['openvpn']['logrotate']['rotate_days'] = '15'

# AWS
default['use_iam_role'] = false
