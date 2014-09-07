# CHANGELOG

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
