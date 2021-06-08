# Cookbook:: linux_base_cookbook
# Recipe:: debian_packages
#
# Copyright:: 2018, Cosmin Banciu, All Rights Reserved.

# install standard packages
apt_update 'update'
 ['git', 'libssl1.0.0', 'libssl-dev', 'htop',
  'openssh-client', 'openvpn', 'squid', 'curl', 'wget', 'nfs-common',
  'rpcbind', 'autofs', 'rbenv', 'ruby-build', 'build-essential',
  'libffi-dev', 'ruby-full', 'gnupg2', 'mc', 'ntfs-3g', 'netbase', 'nano',
  'logrotate', 'gzip', 'zip', 'tar', 'gcc', 'g++', 'ftp', 'iproute2',
  'iptables', 'ufw', 'unzip', 'telnet', 'whois', 'vsftpd',
  'software-properties-common', 'dirmngr', 'python3', 'python3-pip',
  'stress', 'tree', 'samba'].each do |package|
    apt_package package do
      action :install
    end
  end

include_recipe 'poise-python'
include_recipe 'java'
