# Cookbook:: linux_base_cookbook
# Recipe:: aws
#
# Copyright:: 2018, Cosmin Banciu, All Rights Reserved.

include_recipe 'aws'

# get my public ip
bash 'get public ip' do
  user ''
  code <<-EOH
    dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}' > /home//public_ip
  EOH
end

if File.exist?('/home//public_ip')
  public_ip = ::File.read('/home//public_ip').chomp
end

if node['use_iam_role'] == false
  aws = data_bag_item('aws', '_aws_keys')

  directory '/home//.aws' do
    owner ''
    group ''
    mode '0700'
    action :create
  end

  template '/home//.aws/credentials' do
    source 'credentials.conf.erb'
    action :create_if_missing
    owner ''
    group ''
    mode '0644'
    variables  aws_access_key_id: aws['aws_access_key_id'],
               aws_secret_access_key: aws['aws_secret_access_key']
  end

  template '/home//.aws/config' do
    source 'config.conf.erb'
    action :create_if_missing
    owner ''
    group ''
    mode '0644'
  end

  route53_record 'create a test record' do
    aws_access_key aws['aws_access_key_id']
    aws_secret_access_key aws['aws_secret_access_key']
    name  'node01.mydomain.net'
    value public_ip
    type  'A'
    weight '1'
    set_identifier 'test-identifier'
    zone_id 'Z1XQ8CNQKNPKEC'
    overwrite true
    fail_on_error false
    action :create
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
  user ''
  code <<-EOH
    awscli s3 ls
  EOH
  not_if { ::File.exist?('/usr/local/bin/aws') }
end
