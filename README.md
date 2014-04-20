# chef-continuum-anaconda cookbook

Chef cookbook for installing [Continuum Analytic](http://continuum.io/)'s
[Anaconda](https://store.continuum.io/cshop/anaconda/): "completely free Python
distribution for large-scale data processing, predictive analytics, and
scientific computing".

This also serves as a live example of the most up-to-date best practices for
writing, maintaining, and testing Chef cookbooks:

- [Berkshelf 3](http://berkshelf.com/) for dependency resolution
- [Vagrant](https://www.vagrantup.com) for development
- [Chefspec](https://github.com/sethvargo/chefspec) for rapid testing
- [Test Kitchen](https://github.com/test-kitchen/test-kitchen) for comprehensive testing across multiple platforms
- [Foodcritic](http://acrmp.github.io/foodcritic/) for style checking

# Requirements

Chef 11.x

# Usage, recipes, and attributes

This cookbook only has one recipe: `chef-continuum-anaconda::default`. Include
it in your runlist, and it will install the package as well as any necessary
dependencies.

The following are user-configurable attributes. Check [attributes/default.rb](attributes/default.rb) for default values.

- `anaconda`
  - `version`: the version to install
  - `flavor`: either 'x86' (32-bit) or 'x86_64' (64-bit)
  - `install_root`: the parent directory of all anaconda installs. note that installs go into `#{install_root}/#{version}`
  - `add_to_shell_path`: TODO
  - `owner`: the user who owns the install
  - `group`: the group who owns the install

# Tests

Run the full test suite:

```bash
# this will take a long time
$> script/cibuild
...

# check the final result; bash return codes: 0 is good, anything else is not
$> echo $?
```

Run just the [chefspecs](spec/default_spec.rb):

```bash
$> rspec
```

Run just the test kitchen [integration tests](test/integration/default/serverspec/default_spec.rb):

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
