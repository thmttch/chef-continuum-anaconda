default.anaconda.version = '2.2.0'
default.anaconda.flavor = 'x86'
default.anaconda.installer = {
  '1.8.0' => {
    'uri_prefix' => 'http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com',
    'x86' => '9eeda2307e9f5c7927ce610fc9dcd632c3d42fab',
    'x86_64' => '44da25d5fec8a1acc26bad816c928e002d877334',
  },
  '1.9.2' => {
    'uri_prefix' => 'http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com',
    'x86' => '806a8edec3cde7d3e883fe6fda6999b643766e06',
    'x86_64' => '8b3d2800b555c28879f51373ea8ca32c3c79a424',
  },
  '2.0.1' => {
    'uri_prefix' => 'http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com',
    'x86' => '7384b070191967f205e7856e9c82396867e22601',
    'x86_64' => 'd5b0e4e3619bd75fedcb0dafa585886198ec7014',
  },
  '2.1.0' => {
    'uri_prefix' => 'http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com',
    'x86' => 'fd70c08719e6b5caae45b7c8402c6975a8cbc0e3e2a9c4c977554d1784f28b72',
    'x86_64' => '191fbf290747614929d0bdd576e330c944b22a67585d1c185e0d2b3a3e65e1c0',
  },
  '2.2.0' => {
    'uri_prefix' => 'https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com',
    'x86' => '6437d5b08a19c3501f2f5dc3ae1ae16f91adf6bed0f067ef0806a9911b1bef15',
    'x86_64' => 'ca2582cb2188073b0f348ad42207211a2b85c10b244265b5b27bab04481b88a2',
  },
  '3-2.2.0' => {
    'uri_prefix' => 'https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com',
    'x86' => '223655cd256aa912dfc83ab24570e47bb3808bc3b0c6bd21b5db0fcf2750883e',
    'x86_64' => '4aac68743e7706adb93f042f970373a6e7e087dbf4b02ac467c94ca4ce33d2d1',
  },
  'miniconda-python2' => {
    'uri_prefix' => 'https://repo.continuum.io/miniconda',
    # miniconda is always latest, so it doesn't have a stable checksum
    'x86' => nil,
    'x86_64' => nil,
  },
  'miniconda-python3' => {
    'uri_prefix' => 'https://repo.continuum.io/miniconda',
    'x86' => nil,
    'x86_64' => nil,
  }
}

# specific versions are installed _under_ this directory
default.anaconda.install_root = '/opt/anaconda'
default.anaconda.accept_license = 'no'
default.anaconda.package_logfile = nil

default.anaconda.owner = 'vagrant'
default.anaconda.group = 'vagrant'
default.anaconda.home = "/home/#{node.anaconda.owner}"
