# Cookbook:: cos_linux_base
# Recipe:: debian_packages
#
# Copyright:: 2018, Cosmin Banciu, All Rights Reserved.

# install standard packages
apt_update 'update'
 ['git', 'libssl1.0.0', 'libssl-dev',
  'openssh-client', 'squid', 'curl', 'wget', 'nfs-common',
  'rpcbind', 'autofs', 'rbenv', 'ruby-build', 'build-essential',
  'libffi-dev', 'python', 'python-pip', 'ruby-full', 'gnupg2', 'mc',
  'ntfs-3g', 'netbase', 'nano', 'logrotate', 'gzip', 'zip', 'tar',
  'gcc', 'g++', 'ftp', 'iproute2', 'iptables', 'ufw', 'unzip', 'telnet',
  'whois', 'vsftpd', 'software-properties-common', 'dirmngr',
  'stress', 'tree', 'samba'].each do |package|
    apt_package package do
      action :install
    end
    if node['install_java'] == true
      include_recipe 'java'
    end
  end
