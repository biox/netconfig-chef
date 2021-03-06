name 'netconfig'
maintainer 'Jesse Olson'
maintainer_email 'jesse@arkham.city'
license 'GPLv3'
description 'Installs/Configures netconfig'
long_description 'Installs/Configures netconfig'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)
issues_url 'https://github.com/bioxcession/netconfig/issues'
source_url 'https://github.com/bioxcession/netconfig'

depends 'poise-python', '~> 1.6.0'
depends 'nginx', '~> 7.0.2'
