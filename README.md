# linux_base_cookbook

This cookbook performs a basic linux configuration: users, packages, aws configuration, openvpn, vsftpd, squid and others.
The cookbook is built for Ubuntu 18.04 LTS and must be used in combination with AWS Route53 DNS.
It detects if the chef node is on-prem or ec2 and register its hostname based on the -N parameter given at bootstrap.
To use this cookbook you must know how to work with Chef and have proper env and data bags in place.
Obs.: Use it at your own risk and change it as needed.

Bootstrap example: knife bootstrap  IP -N FQDN_NODE_NAME -E ENV_NAME -r 'recipe[linux_base_cookbook], recipe[other_recipe]' --ssh-user ubuntu --sudo --bootstrap-version 13.9.1 --secret-file ~/.chef/my_secret_databag_file

11.2018
