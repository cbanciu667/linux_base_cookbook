
name 'linux_base_cookbook'
maintainer          'Cosmin Banciu'
maintainer_email    'cosmin.banciu667@gmail.com'
license             'Apache 2.0'
description         'Installs/Configures role_cosmin_merlinsrv'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.4'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/linux_base_cookbook/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/linux_base_cookbook'

depends 'apt'
depends 'aws'
depends 'chef-client'
depends 'cron'
depends 'dynamic_motd'
depends 'nfs'
depends 'java'
depends 'logrotate'
depends 'openvpn'
depends 'openssh'
depends 'poise-python'
depends 'rsync'
depends 'ruby'
depends 'system'
depends 'sudo'
depends 'yum-epel'
