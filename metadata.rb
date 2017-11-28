name              'anaconda'
maintainer        'Matt Chu'
maintainer_email  'matt.chu@gmail.com'
license           'MIT'
description       'Installs/Configures anaconda'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.7.0'

source_url        'https://github.com/thmttch/chef-continuum-anaconda'
issues_url        'https://github.com/thmttch/chef-continuum-anaconda/issues'

chef_version '>= 13'

supports 'ubuntu', '= 14.04'
supports 'ubuntu', '= 16.04'

supports 'debian', '= 8.9'
supports 'debian', '= 9.2'

supports 'centos', '= 6.9'
supports 'centos', '= 7.4'

depends 'apt'
depends 'runit'
depends 'bzip2'
depends 'tar'
