# CHANGELOG

## 0.7.3 (in development)

- Added anaconda 5.1.0 and 5.2.0
- Template changed to really skip the license text (one space is not sufficent)lms

## 0.7.2

**This is a backwards-INCOMPATIBLE release**

- Catch up with ipython -> jupyter rebranding: renamed everything to jupyter.
  This includes directories, attributes, and other backwards-incompatible
  changes.
- More fixes to release process: don't include unnecessary files during berkshelf
  vendoring and release
- Vagrant and notebook server fixes
  - you can use attributes to set the notebook server's security token. _Be
    careful with this config!_ It is disabled in the quickstart Vagrant setup
    for convenience, and remains _enabled by default_.
- Foodcritic fixes; resolves:
  - FC017: LWRP does not notify when updated: anaconda/providers/nbservice.rb:21
  - FC017: LWRP does not notify when updated: anaconda/providers/package.rb:21
  - FC017: LWRP does not notify when updated: anaconda/providers/package.rb:58
  - FC059: LWRP provider does not declare use_inline_resources: anaconda/providers/nbservice.rb:1
  - FC059: LWRP provider does not declare use_inline_resources: anaconda/providers/package.rb:1
  - FC048: Prefer Mixlib::ShellOut: ./providers/nbservice.rb:12
  - FC048: Prefer Mixlib::ShellOut: ./providers/package.rb:12

## 0.7.1

**This cookbook is now up for adoption! See CONTRIBUTING.md for details.**

- Post release cleanup:
  - release script and better document release process
  - remove references to Chef DK
- (WIP!) Update Vagrant instructions:
  - Use Vagrant 2.0
  - Update image to use Ubuntu 16.04 LTS (xenial), from 14.04 LTS
- Lint/Quality
  - Added CONTRIBUTING.md
  - Added TESTING.md, and move content from README.md to that file
  - Remove vim swapfiles from release, because chefignore doesn't seem to do
    shit.
- Added checksums for new 5.0 Anaconda installers

## 0.7.0

Many, many changes and fixes to support both the latest Chef version and the
latest Anaconda versions.

Adds support for Anaconda 4.4.0 and 5.0.1! 5.0.1 is now the default.

### Cookbook changes:

- Adds a `system_path` attribute, for adding Anaconda's bin path to `PATH`.

### Chef changes:

- Dot notation attributes (eg `node.attr1.prop1`) have been deprecated and is
  now an error; converted everything to hash/bracket notation (eg
  `node['attr1']['prop1']`).
- Cleanups to metadata.rb.

### Updated tested list of OSes

The list of tested OSes has been refined to the latest and penultimate (major)
stable versions. Note that just because an OS is not on the tested list does
not mean it won't work, it just means it is not part of the official test
suite. My experience has been it generally will.

- Ubuntu:
  - Removed tests for: 12.04, 15.04
  - Added tests for: 16.04
- Debian:
  - Removed tests for: 7.8, 8.1
  - Added tests for: 8.9, 9.1
- CentOS:
  - Removed tests for: 5.11, 6.6, 7.1
  - Added tests for: 6.9, 7.4
- Red Hat: completed removed from test suite, in favor of CentOS only

### Development, fixes:

- Gemfile now annotated with rvm metadata for ruby version and gemset.
- Fixed vagrant-trigger to correctly populate /var/chef/cache on provision.
- Fixed bad call to `Chef::Log` with `fatal`.

## 0.6.2

First official 0.6.x release; see 0.6.0 changelog for details.

Note that this reverts the release process back to using Chef 11.x/ChefDK 0.3.6
because of <https://github.com/chef/chef/issues/3888>.

## 0.6.1 (broken, untagged release thanks to ChefDK)

Do not use.

## 0.6.0 (unreleased thanks to ChefDK)

**This is a backwards-INCOMPATIBLE release**

API, cookbook changes:

- Refactored attributes to be cleaner and more readable
- The user and group are now created if they don't exist, and by default are
  installed under anaconda/anaconda
- New attributes for configuring notebook server
- The OS architecture (x86 versus x86_64) is now autodetected by default

Platform, support changes:

- Added support for Anaconda 2.3 (all pythons and all architectures)
- Removed support for all Anacondas < 2.2.0
- updated metadata.rb 'supports' tags (hopefully this doesn't break anything)

Tools changes:

- Migrated to chefdk 0.8.1
  - upgraded gems
  - updated chefspec
  - updated documentation
  - removed rbenv/rvm files

Testing changes:

- Moved to kitchen-docker for Docker-based testing, which is much much much
  faster
- Updated supported (tested) platforms:
  - ubuntu:
    - removed: 12.10, 13.04, 13.10
    - added: 15.04
  - debian:
    - removed: 6.0.5
    - added: 7.8, 8.1 (7.9 and 8.2 not in fauxhai yet)
  - centos:
    - removed: 5.8, 6.0, 6.3
    - added: 5.11, 6.6, 7.1.1503
  - redhat (chefspec only, no kitchen testing):
    - removed: 5.8, 6.3
    - added: 5.9, 6.6, 7.1.1503

## 0.5.1

- Added support for Anaconda 2.2.0 with Python 3
  - Courtesy: https://github.com/nareynolds
- Minor cleanup: remove unused file

## 0.5.0

- Upgraded to Anaconda 2.2.0 from 2.0.1
  - Includes support for Anaconda 2.1.0
- Added support for [Miniconda](http://conda.pydata.org/miniconda.html)
- Upgraded Vagrantfile:
  - Upgraded Chef from 11.16+ to 12+ to match Kitchen tests
  - Upgraded OS from 12.04 to 14.04

## 0.4.4

Backwards-compatible fix for issue when using both the python cookbook and this
one. Issue: https://github.com/thmttch/chef-continuum-anaconda/issues/12

## 0.4.3

Unintended release, thanks to Chef Supermarket's crappiness.

## 0.4.2

New resource 'anaconda_nbservice', for running an IPython notebook server.
Somewhat experimental, it's fairly basic but usable.

## 0.4.1

Hotfix release:

- bad attribute name broke conda package installs and removes. Identified by
  https://github.com/thmttch/chef-continuum-anaconda/issues/8, fixed by
  https://github.com/thmttch/chef-continuum-anaconda/pull/9. Cheers to
  @touchdown for the report.

## 0.4.0

Major cleanup and basic usability fixes (read: almost not sure why it worked
before, if it even did):

- (core, breaking) Renamed `anaconda::shell-conveniences` to
  `anaconda::shell_conveniences`
- (core, breaking) No longer uses the `python` cookbook; this caused problems
  after anaconda was installed
- (core) `shell_conveniences` now installs into `/etc/profile.d`, so it is
  automatically sourced by login shells
- (core) Ubuntu 14.04 is now a supported (and fully tested) platform
- (core) Ubuntu 14.04 is now the default platform used in the sample Vagrantfile
- (core) Vagrantfile now correctly installs Anaconda, like the README said it
  was supposed to
- (docs) various readme updates
- (testing) Complete coverage of all resources in chefspec
- (testing) Removed Ubuntu 12.10 and 13.04 from kitchen testing; there's
  something wrong with `apt-get` on these images. It [appears to
  be](http://ubuntuforums.org/showthread.php?t=1542755) [something about the
  apt keys](http://ubuntuforums.org/showthread.php?p=7001019#7001019), but
  they're just removed from testing for now.

## 0.3.3

Bugfix release:

- Fixes related to install script and permissions
  ([#5](https://github.com/thmttch/chef-continuum-anaconda/pull/5)). Courtesy
  @mwalton236

## 0.3.1

New resource: `anaconda_package`, for installing and removing packages via
`conda`

## 0.3.0

Rewrote all project history

## 0.2.1

Fix incorrect checksums for Anaconda 2.0.1

## 0.2.0

Feature improvments:

- updated the default installation to Anaconda 2.0.1, from 1.9.2

Miscellaneous:

- minor `cibuild` improvement to ensure clean tests
- minor code changes to support updated toolchain
- removed Chef Development Kit recommendation after experimenting with it
