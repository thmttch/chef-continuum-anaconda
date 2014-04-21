name             'anaconda'
maintainer       'Matt Chu'
maintainer_email 'matt.chu@gmail.com'
license          'MIT'
description      'Installs/Configures anaconda'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports 'ubuntu', '= 12.04'
supports 'ubuntu', '= 13.04'
supports 'ubuntu', '= 13.10'

depends 'apt'
depends 'python'
