default.anaconda.version = '2.0.1'
default.anaconda.flavor = 'x86'
default.anaconda.installer = {
  '1.8.0' => {
    'x86' => '9eeda2307e9f5c7927ce610fc9dcd632c3d42fab',
    'x86_64' => '44da25d5fec8a1acc26bad816c928e002d877334',
  },
  '1.9.2' => {
    'x86' => '806a8edec3cde7d3e883fe6fda6999b643766e06',
    'x86_64' => '8b3d2800b555c28879f51373ea8ca32c3c79a424',
  },
  '2.0.1' => {
    'x86' => '7384b070191967f205e7856e9c82396867e22601',
    'x86_64' => 'd5b0e4e3619bd75fedcb0dafa585886198ec7014',
  },
}

# specific versions are installed _under_ this directory
default.anaconda.install_root = '/opt/anaconda'
default.anaconda.accept_license = 'no'
default.anaconda.install_logfile = ''

default.anaconda.owner = 'vagrant'
default.anaconda.group = 'vagrant'
default.anaconda.home = "/home/#{node.anaconda.owner}"
