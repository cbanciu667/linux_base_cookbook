def cos_cookbook(name, version = '>= 0.0.0', options = {})
  cookbook(name, version, {
    git: "git@github.com:user667/#{name}.git"
   }.merge(options))
end

def local_cookbook(cookbook_dir, version = '>= 0.0.0', options = {})
  cookbook(cookbook_dir, version, {
    path: "#{ENV['CHEF_COOKBOOK_HOME']}/cookbooks/#{cookbook_dir}"
   }.merge(options))
end
source 'https://supermarket.getchef.com'

metadata

cookbook 'apt'
cookbook 'aws'
cookbook 'chef-client'
cookbook 'cron'
cookbook 'dynamic_motd'
cookbook 'nfs'
cookbook 'java'
cookbook 'logrotate'
cookbook 'openvpn'
cookbook 'openssh'
cookbook 'poise-python'
cookbook 'rsync'
cookbook 'ruby'
cookbook 'sudo'
local_cookbook 'system'
cookbook 'yum-epel'
