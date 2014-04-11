name             'chef-continuum-anaconda'
maintainer       'Matt Chu'
maintainer_email 'matt.chu@gmail.com'
license          'MIT'
description      'Installs/Configures chef-continuum-anaconda'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports 'ubuntu', '= 12.04'

depends 'apt'
depends 'python'
