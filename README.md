# chef-continuum-anaconda cookbook

Chef cookbook for installing [Continuum Analytic](http://continuum.io/)'s
[Anaconda](https://store.continuum.io/cshop/anaconda/): "completely free Python
distribution for large-scale data processing, predictive analytics, and
scientific computing".

This also serves as a example of the most up-to-date best practices for
writing, maintaining, and testing Chef cookbooks:

- Berkshelf 3 for dependency resolution
- Vagrant for development
- Chefspec for rapid testing
- Test Kitchen for comprehensive testing across multiple platforms
- Foodcritic for style checking

# Requirements

# Usage, recipes, and attributes

This cookbook only has one recipe: `chef-continuum-anaconda::default`. Include
it in your runlist, and it will install the package as well as any necessary
dependencies.

The following are user-configurable attributes. Check <attributes/default.rb> for default values.

- anaconda
  - version: the version to install
  - flavor: either 'x86' (32-bit) or 'x86_64' (64-bit)
  - install_root: the parent directory of all anaconda installs. note that installs go into `#{install_root}/#{version}`
  - add_to_shell_path: TODO
  - owner: the user who owns the install
  - group: the group who owns the install

# Tests

Run the full test suite:

```bash
# this will take a long time
$> script/cibuild
...

# check the final result; bash return codes: 0 is good, anything else is not
$> echo $?
```

Run just the [chefspec](https://github.com/sethvargo/chefspec)s:

```bash
$> rspec
```

Run just the [test kitchen](https://github.com/test-kitchen/test-kitchen) full integration tests:

```bash
$> rspec
```

Check the style with [Foodcritic](http://acrmp.github.io/foodcritic/):

```bash
$> foodcritic
```

# TODO

- autodetect 64-bit versus 32

# Author

Author:: Matt Chu (matt.chu@gmail.com)
