#!/usr/bin/env bash

cat <<-INSTRUCTIONS
Prep for release:

1. Cut a github release
2. Locally checkout the release tag
3. If not available, log into Supermarket and generate a new key via Manage
   Profile. Update release-config.rb accordingly.

Upload to supermarket:

# Use berkshelf to vendor a clean version of the cookbook; REMOVE ALL VIM
# SWAPFILES! chefignore doesn't seem to do shit.
$> find . -name *.swp | xargs -I[] rm -vf []
$> berks vendor cookbooks
# Upload to supermarket
$> knife cookbook site share anaconda "Programming Languages" --cookbook-path cookbooks --supermarket-site https://supermarket.chef.io --config script/release-config.rb

Post-release:

1. Bump metadata.rb version for next release! master is development
INSTRUCTIONS
