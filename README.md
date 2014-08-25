# anaconda cookbook

Chef cookbook for installing [Continuum Analytic](http://continuum.io/)'s
[Anaconda](https://store.continuum.io/cshop/anaconda/): "completely free Python
distribution for large-scale data processing, predictive analytics, and
scientific computing".

This also serves as a live example of the most up-to-date best practices for
writing, maintaining, and testing Chef cookbooks:

- [Berkshelf 3](http://berkshelf.com/) for dependency resolution
- [Vagrant](https://www.vagrantup.com) for development
- [Chefspec](https://github.com/sethvargo/chefspec) for rapid testing
- [Test Kitchen](https://github.com/test-kitchen/test-kitchen) for
comprehensive testing across multiple platforms, with tests written in
[serverspec](http://serverspec.org/)
- [Foodcritic](http://acrmp.github.io/foodcritic/) for style checking

## Requirements

This repo has only been tested with RVM; YMMV with other installation methods
(rbenv, chef-dk, etc).

- Berkshelf 3.1.3
- Chefspec 4.0.0
- Test Kitchen 1.2.1
- Foodcritic 4.0.0
- Vagrant 1.6+
  - [vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus)
  - [vagrant-berkshelf](https://github.com/berkshelf/vagrant-berkshelf): note
    that `>= 2.0.1` is required

It sounds like [Chef-DK](http://www.getchef.com/downloads/chef-dk/) is the new
recommended installation path, but I have not had a good experience with it (as
of *0.1.0-1*). Again, YMMV.

## Quickstart

The [Vagrantfile](Vagrantfile) is written to get you an Anaconda environment
with minimal effort:

```bash
$> vagrant up --provision
...

$> vagrant ssh
$vagrant> export PATH=/opt/anaconda/2.0.1/bin:${PATH}
$vagrant> conda --version
conda 3.5.5

# if you included `recipe[anaconda::shell_conveniences]` you don't have to do anything;
# it's sourced in /etc/profile.d
$> vagrant ssh
$vagrant> conda --version
conda 3.5.5
```

In addition, by default an IPython notebook server is enabled and started:

  http://33.33.33.123:8888

To use it in a cookbook:

```ruby
include_recipe 'anaconda::default'
```

## Usage, recipes, attributes, and resources

The main recipe is `anaconda::default`. Include it in your runlist, and it will
install the package as well as any necessary dependencies.

The following are user-configurable attributes. Check
[attributes/default.rb](attributes/default.rb) for default values.

- `anaconda`
  - `version`: the version to install
  - `flavor`: either `x86` (32-bit) or `x86_64` (64-bit)
  - `install_root`: the parent directory of all anaconda installs. note that
    individual installs go into `#{install_root}/#{version}`
  - `accept_license`: must be explicitly set to the string `yes`; any other
    value will reject the license.
  - `owner`: the user who owns the install
  - `group`: the group who owns the install

### `recipe[anaconda::shell_conveniences]`

Include this to have the environment set for all users (login shells) via
`/etc/profile.d`.  Useful for development.

```bash
$> vagrant ssh
$vagrant> which conda
/opt/anaconda/2.0.1/bin/conda
```

### resource `anaconda_package`

You can use the `anaconda_package` resource to install new packages into the
Anaconda environment:

```ruby
# I do not know what 'astroid' is, just using it as a sample package
anaconda_package 'astroid' do
  # the other supported action is `:remove`
  action :install
end
```

See the [resource definition](resources/package.rb) for additional options; in
general, all it does is present the same options as `conda install`/`conda
remove`.

### resource `anaconda_nbservice`

The `anaconda_nbservice` will run an IPython notebook server as a runit
service:

```ruby
anaconda_nbservice 'notebook-server' do
  # listen on all interfaces; there will be a warning since security is
  # disabled
  ip '*'
  port '8888'

  user 'vagrant'
  group 'vagrant'

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

Run the full test suite:

```bash
# this will take a really long time
$> script/cibuild
...

# check the final result; bash return codes: 0 is good, anything else is not
$> echo $?
```

Run just the [chefspecs](spec/default_spec.rb):

```bash
$> rspec
```

Run just the test kitchen serverspec [integration
tests](test/integration/default/serverspec/default_spec.rb):

```bash
# this is what takes so long: every platform and version is fully built in vagrant
# the list of OSes is defined in [.kitchen.yml](.kitchen.yml)
$> kitchen verify

# test a specific OS; `kitchen list`
$> kitchen verify default-ubuntu-1204
```

Check the style with [Foodcritic](http://acrmp.github.io/foodcritic/):

```bash
$> foodcritic
```

## Releases and issues

Standard stuff:

- master is the active version in development
- releases are [made with
  Github](https://github.com/thmttch/chef-continuum-anaconda/releases), and
  `git tag`'ed

Issues should be [opened in the Github issue
tracker](https://github.com/thmttch/chef-continuum-anaconda/issues)

## TODO

- autodetect 64-bit versus 32
- (TODO does it matter? who uses it?) populate metadata.rb: `suggests`,
  `supports`, etc
- add a pre-provision for kitchen tests to avoid redownloading the installer on
  every test (really slows down the tests)
- figure out how to publish onto http://community.opscode.com/; the
  documentation is unbelievably bad

## Author

Author:: Matt Chu (matt.chu@gmail.com)
