# anaconda cookbook

**This cookbook is now up for adoption! See CONTRIBUTING.md for details.**

Chef cookbook for installing [Continuum Analytic](http://continuum.io/)'s
[Anaconda](https://store.continuum.io/cshop/anaconda/): "completely free Python
distribution for large-scale data processing, predictive analytics, and
scientific computing". Specifically:

- Anaconda 2.2, 2.3, 4.4.0, 5.0.1, 5.1.0, 5.2.0 (the default)
  - python2 or python3
  - x86 or x86_64
- Miniconda
  - python2 or python3
  - x86 or x86_64
- Usage tested on Ubuntu, unittested on Debian, CentOS, and RedHat. See [rspec
  tests](spec/default_spec.rb#L101) and [kitchen tests](.kitchen.yml#L18) for
  the full list.

This also serves as an example for developing and testing Chef cookbooks. It
uses:

- ~[ChefDK](https://downloads.chef.io/chef-dk/)~ Given up on this for
  now; uses standard RVM and Gemfile to manage installation
  - chef-client 13.6
  - [Berkshelf](http://berkshelf.com) for dependency resolution; 6.3
  - [Test Kitchen](https://github.com/test-kitchen/test-kitchen) for
    comprehensive testing across multiple platforms, with tests written in
    [serverspec](http://serverspec.org); 1.19
    - Docker, with
      [kitchen-docker](https://github.com/portertech/kitchen-docker)
      integration
  - [Foodcritic](http://acrmp.github.io/foodcritic/) for style checking; 12.2
- RSpec (3.7)/[Chefspec](https://github.com/sethvargo/chefspec) (7.1) for unit testing

In addition:

- [Vagrant](https://www.vagrantup.com) to provide an out-of-the-box working
  example; only tested with 2.0.

## Requirements

If you want to just have a working Anaconda VM, install:

- Vagrant
  - [vagrant-triggers](https://github.com/emyl/vagrant-triggers)

For the full experience (e.g. running the test suite), also install:

- [vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus)
- [vagrant-berkshelf](https://github.com/berkshelf/vagrant-berkshelf)
- Docker

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
  conda 4.3.30

  # or you add it to PATH manually
  $> vagrant ssh
  $vagrant> export PATH=/opt/anaconda/5.0.1/bin:${PATH}
  $vagrant> conda --version
  conda 4.3.30
  ```

It includes a Jupyter notebook server accessible at
<http://33.33.33.123:8888>. **Token authentication is disabled in the
quickstart Vagrant setup.**

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
    - 4.4.0
    - 5.0.1
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
  - `system_path`: adds the bin path to the system's profile.d directory

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

    install_dir '/opt/jupyter/server'

    service_action [ :enable, :start ]
  end
  ```

The standard configuration should be good enough, but you might need to write
your own run service template:

  ```ruby
  anaconda_nbservice 'server-with-custom-template' do
    user jupyter_user
    group jupyter_group

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

## Developer setup, config, and tests

See [TESTING.md](TESTING.md) for details.

## Releases and issues

Standard stuff:

- master is the active version in development
- releases are [made with
  Github](https://github.com/thmttch/chef-continuum-anaconda/releases), and
  `git tag`'ed
- issues should be [opened in the Github issue
  tracker](https://github.com/thmttch/chef-continuum-anaconda/issues)

## TODO

- https://github.com/poise/python is now deprecated, in favor of
  https://github.com/poise/poise-python; see if the python workaround is still
  necessary
  - the supermarket version (https://supermarket.chef.io/cookbooks/python)
    looks like it also points to the deprecated one

## Author

Author:: Matt Chu (matt.chu@gmail.com)
