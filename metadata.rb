name              'anaconda'
maintainer        'Matt Chu'
maintainer_email  'matt.chu@gmail.com'
license           'MIT'
description       'Installs/Configures anaconda'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '1.0.0'

# TODO enable once release chefdk works for me
#source_url        'https://github.com/thmttch/chef-continuum-anaconda'
#issues_url        'https://github.com/thmttch/chef-continuum-anaconda/issues'

supports 'ubuntu', '= 12.04'
supports 'ubuntu', '= 14.04'
supports 'ubuntu', '= 15.04'

supports 'debian', '= 7.8'
supports 'debian', '= 8.1'

supports 'centos', '= 5.11'
supports 'centos', '= 6.6'
supports 'centos', '= 7.1.1503'

# TODO
#supports 'redhat', '= 5.9'
#supports 'redhat', '= 6.6'
#supports 'redhat', '= 7.1'

depends 'apt'
depends 'runit'
depends 'bzip2'
depends 'tar'
