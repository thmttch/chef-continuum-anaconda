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

This repo has only been tested with RVM; YMMV with other installation methods (rbenv, chef-dk, etc).

- Berkshelf 3.1.3
- Chefspec 4.0.0
- Test Kitchen 1.2.1
- Foodcritic 4.0.0
- Vagrant 1.6+
  - [vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus)
  - [vagrant-berkshelf](https://github.com/berkshelf/vagrant-berkshelf): note that `>= 2.0.1` is required

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
```

To use it in a cookbook:

```ruby
include_recipe 'anaconda::default'
```

## Usage, recipes, and attributes

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

### `recipe[anaconda::shell-conveniences]`

Include this to have a `source-me.sh` added to `${HOME}` which you can source
on login. Useful for development.

```bash
$> vagrant ssh
$vagrant> source source-me.sh
$vagrant> which conda
/opt/anaconda/2.0.1/bin/conda
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
$> kitchen verify
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
