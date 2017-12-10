# anaconda cookbook: Testing

## Developer setup and config

You can try [installing Chef DK](https://docs.chef.io/install_dk.html), but
I've found it much easier to just use RVM and Bundler to manage ruby and gems;
YMMV.

### Tests

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
  $> kitchen verify default-ubuntu-1604
  ```

- check for style issues with Foodcritic

  ```bash
  $> foodcritic
  ```
