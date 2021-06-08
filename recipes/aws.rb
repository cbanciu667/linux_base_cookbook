# Cookbook:: linux_base_cookbook
# Recipe:: aws
#
# Copyright:: 2018, Cosmin Banciu, All Rights Reserved.

include_recipe 'aws'

record_name = node.name

# non ec2 node
if node['ec2_with_iam_role'] == false
  # get aws keys from databag
  aws = data_bag_item('aws', 'USER2_aws_keys')

  directory '/home/USER2/.aws' do
    owner 'USER2'
    group 'USER2'
    mode '0700'
    action :create
  end

  template '/home/USER2/.aws/credentials' do
    source 'credentials.conf.erb'
    action :create_if_missing
    owner 'USER2'
    group 'USER2'
    mode '0644'
    variables  aws_access_key_id: aws['aws_access_key_id'],
               aws_secret_access_key: aws['aws_secret_access_key']
  end

  template '/home/USER2/.aws/config' do
    source 'config.conf.erb'
    action :create_if_missing
    owner 'USER2'
    group 'USER2'
    mode '0644'
  end

  # if node is not ec2 instance. e.g. physical machine
  # get my public ip
  bash 'get public ip' do
    user 'USER2'
    code <<-EOH
      dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}' > /home/USER2/public_ip
    EOH
  end
  if File.exist?('/home/USER2/public_ip')
    public_ip = ::File.read('/home/USER2/public_ip').chomp
  end
  route53_record "#{record_name}" do
    aws_access_key aws['aws_access_key_id']
    aws_secret_access_key aws['aws_secret_access_key']
    name  record_name
    value public_ip
    type  'A'
    weight '1'
    set_identifier 'test-identifier'
    zone_id node['route_53']['zone_id']
    overwrite true
    fail_on_error false
    action :create
    not_if { node['system']['domain_name'] == 'localdomain' }
  end
  # cloutwatch logs agent
  node.normal['aws_cwlogs']['aws_access_key_id'] = aws['aws_access_key_id']
  node.normal['aws_cwlogs']['aws_secret_access_key'] = aws['aws_secret_access_key']
  include_recipe 'aws-cloudwatchlogs'
  aws_cwlogs 'syslog' do
    log node['aws_cwlogs']['log']['syslog']
   end
  aws_cwlogs 'messages' do
    log node['aws_cwlogs']['log']['messages']
  end
  aws_cwlogs 'dpkg' do
    log node['aws_cwlogs']['log']['dpkg']
   end
  aws_cwlogs 'auth' do
    log node['aws_cwlogs']['log']['auth']
  end

  # if ec2 instance
else
  # with public ip
  if (node['ec2'].attribute?('public_ipv4') && !node['ec2']['public_ipv4'].nil?)
      route53_record "#{record_name}" do
        name  record_name
        value node['ec2']['public_ipv4']
        type  'A'
        weight '1'
        set_identifier 'test-identifier'
        zone_id node['route_53']['zone_id']
        overwrite true
        fail_on_error false
        action :create
        not_if { node['system']['domain_name'] == 'localdomain' }
      end
   # without public ip
   else
       route53_record "#{record_name}" do
         name  record_name
         value node['ec2']['local_ipv4']
         type  'A'
         weight '1'
         set_identifier 'test-identifier'
         zone_id node['route_53']['zone_id']
         overwrite true
         fail_on_error false
         action :create
         not_if { node['system']['domain_name'] == 'localdomain' }
      end
   end
   # tag instance
   aws_resource_tag node['ec2']['instance_id'] do
      tags('Name' => record_name,'ChefEnvironment' => node.chef_environment)
      action :update
   end
   # include cloudwatch
   include_recipe 'aws-cloudwatchlogs'
   aws_cwlogs 'syslog' do
     log node['aws_cwlogs']['log']['syslog']
    end
   aws_cwlogs 'messages' do
     log node['aws_cwlogs']['log']['messages']
     only_if { ::File.exist?('/var/log/messages') }
   end
   aws_cwlogs 'dpkg' do
     log node['aws_cwlogs']['log']['dpkg']
    end
   aws_cwlogs 'auth' do
     log node['aws_cwlogs']['log']['auth']
   end
   aws_cwlogs 'openvpn' do
     log node['aws_cwlogs']['log']['openvpn']
     only_if { ::File.exist?('/var/log/openvpn.log') }
   end
end

# install awscli
bash 'install awscli' do
  user 'root'
  code <<-EOH
    pip install awscli
  EOH
  not_if { ::File.exist?('/usr/local/bin/aws') }
end

# list s3 buckets
bash 'list s3 buckets' do
  user 'USER2'
  code <<-EOH
    awscli s3 ls
  EOH
  not_if { ::File.exist?('/usr/local/bin/aws') }
end
