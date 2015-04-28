# anaconda cookbook

Chef cookbook for installing [Continuum Analytic](http://continuum.io/)'s
[Anaconda](https://store.continuum.io/cshop/anaconda/): "completely free Python
distribution for large-scale data processing, predictive analytics, and
scientific computing". Specifically:

- Anaconda 2.2 or 2.3
  - python2 or python3
  - x86 or x86_64
- Miniconda
  - python2 or python3
  - x86 or x86_64
- Usage tested on Ubuntu, unittested on Debian, CentOS, and RedHat. See [rspec
  tests](spec/default_spec.rb#L100) and [kitchen tests](.kitchen.yml#L16) for
  the full list.

This also serves as an example for developing and testing Chef cookbooks. It
uses:

- [ChefDK](https://downloads.chef.io/chef-dk/); 0.8.1
  - chef-client 12.4.4
  - [Berkshelf](http://berkshelf.com) for dependency resolution; 3.3.0
  - [Test Kitchen](https://github.com/test-kitchen/test-kitchen) for
    comprehensive testing across multiple platforms, with tests written in
    [serverspec](http://serverspec.org); 1.4.2
    - Docker, with
      [kitchen-docker](https://github.com/portertech/kitchen-docker)
      integration
  - [Foodcritic](http://acrmp.github.io/foodcritic/) for style checking; 5.0.0
- RSpec/[Chefspec](https://github.com/sethvargo/chefspec) for rapid testing;
  3.3.2

In addition:

- [Vagrant](https://www.vagrantup.com) to provide an out-of-the-box working
  example; 1.7.4

## Requirements

If you want to just have a working Anaconda VM, install:

- Vagrant

For the full experience (e.g. running the test suite), also install:

- ChefDK
  - [vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus)
  - [vagrant-berkshelf](https://github.com/berkshelf/vagrant-berkshelf)
- Docker
  - Don't forget [Docker Machine](https://docs.docker.com/machine/) if you're
    on OSX; installing this via homebrew is highly recommended.

## Quickstart

The sample [Vagrantfile](Vagrantfile) will build you an Anaconda VM with no
changes necessary; note it might take a few minutes to download the Anaconda
installer itself.

  ```bash
  $> vagrant up --provision
  ...

  # the sample image includes `recipe[anaconda::shell_conveniences]`, which
  # means conda is already in PATH via /etc/profile.d
  $> vagrant ssh
  $vagrant> conda --version
  conda 3.14.1

  # or you add it to PATH manually
  $> vagrant ssh
  $vagrant> export PATH=/opt/anaconda/2.3.0/bin:${PATH}
  $vagrant> conda --version
  conda 3.14.1
  ```

It includes a Jupyter (IPython) notebook server accessible at <http://33.33.33.123:8888>

Lastly, to use it in a cookbook:

  ```ruby
  include_recipe 'anaconda::default'
  ```

## Warning! If you're also using the [python](https://github.com/poise/python) cookbook...

You MUST include `recipe[anaconda::python_workaround]`, otherwise subsequent
chef runs will fail. See [the
issue](https://github.com/thmttch/chef-continuum-anaconda/issues/12) for
details.

## Usage, recipes, attributes, and resources

The main recipe is `anaconda::default`. Include it in your runlist, and it will
install the package as well as any necessary dependencies.

The following are user-configurable attributes. Check
[attributes/default.rb](attributes/default.rb) for more details.

- `anaconda`
  - `version`: the Anaconda version to install. Valid values are:
    - 2.2.0
    - 2.3.0
    - latest (for miniconda only)
  - `python`: which version of Python to install for. Valid values are:
    - python2
    - python3
  - `flavor`: what architecture the instance is. Valid values are:
    - nil (will autodetect)
    - x86 (32-bit)
    - x86_64 (64-bit)
  - `install_type`: which Anaconda distribution to install. Valid values are:
    - anaconda
    - miniconda
  - `install_root`: the parent directory of all anaconda installs. note that
    individual installs go into `#{install_root}/#{version}`
  - `accept_license`: **must be explicitly set to the string `yes` (there are
    no defaults)**; any other value will reject the license.
  - `owner`: the user who owns the install
  - `group`: the group who owns the install

### `recipe[anaconda::shell_conveniences]`

Include this to have the environment set for all users (login shells) via
`/etc/profile.d`. Useful for development.

### resource `anaconda_package`

You can use the `anaconda_package` resource to install new packages into the
Anaconda environment:

  ```ruby
  # I don't know what 'astroid' is, just using it as a sample package
  anaconda_package 'astroid' do
    # the other supported action is `:remove`
    action :install
  end
  ```

See the [resource definition](resources/package.rb) for additional options; in
general, all it does is present the same options as `conda install`/`conda
remove`.

### resource `anaconda_nbservice`

**This only works with a full Anaconda installation! I.e. the notebook service
will not work out-of-the-box if installed with miniconda.**

The `anaconda_nbservice` will run a Jupyter notebook server as a runit service:

  ```ruby
  anaconda_nbservice 'notebook-server' do
    # listen on all interfaces; there will be a warning since security is
    # disabled
    ip '*'
    port '8888'

    install_dir '/opt/ipython/server'

    service_action [ :enable, :start ]
  end
  ```

The standard configuration should be good enough, but you might need to write
your own run service template:

  ```ruby
  anaconda_nbservice 'server-with-custom-template' do
    user ipython_user
    group ipython_group

    install_dir install_dir

    template_cookbook 'your_cookbook'
    # note that if your template name is TEMPLATE, then this value should be
    # 'TEMPLATE", but the file should be 'sv-TEMPLATE-run.erb'
    run_template_name 'your_template_name'
    run_template_opts({
      ...
    })

    service_action [ :enable, :start ]
  end
  ```

## Tests

To run the full test suite:

  ```bash
  # this will take a while, especially the first time
  $> script/cibuild
  ...

  # check the final result; bash return codes: 0 is good, anything else is not
  $> echo $?
  ```

- to run just the [chefspecs](spec/default_spec.rb):

  ```bash
  $> rspec
  ```

- to run just the test kitchen serverspec [integration
  tests](test/integration/default/serverspec/default_spec.rb):

  ```bash
  # this is done via docker/kitchen-docker
  # the list of OSes is defined in .kitchen.yml
  $> kitchen verify

  # test a specific OS; `kitchen list`
  $> kitchen verify default-ubuntu-1204
  ```

- check for style issues with Foodcritic

  ```bash
  $> foodcritic
  ```

## Releases and issues

Standard stuff:

- master is the active version in development
- releases are [made with
  Github](https://github.com/thmttch/chef-continuum-anaconda/releases), and
  `git tag`'ed
- issues should be [opened in the Github issue
  tracker](https://github.com/thmttch/chef-continuum-anaconda/issues)

## TODO

- populate metadata.rb: `suggests`, `supports`, etc
  - TODO does it matter? who uses it?
- add a pre-provision for kitchen tests to avoid redownloading the installer on
  every test (really slows down the tests)
- figure out how to publish onto http://community.opscode.com/; the
  documentation is unbelievably bad

## Author

Author:: Matt Chu (matt.chu@gmail.com)
