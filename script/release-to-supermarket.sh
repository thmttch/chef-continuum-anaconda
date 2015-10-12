#!/usr/bin/env bash

echo "Don't know how to automate this (creds), so here are the instructions:"
echo ""

echo "cut a github release, checkout that tag locally"
echo ""

echo "use berkshelf to vendor a clean version of the cookbook, and update to supermarket"
echo ""
echo "berks vendor cookbooks"
echo 'knife cookbook site share anaconda "Programming Languages" --cookbook-path cookbooks --config ${CHEF_PUB}'
echo ""
echo "https://docs.getchef.com/knife_cookbook_site.html#share"

echo "BUMP METADATA.RB for next release! master is development"
echo ""

echo "https://supermarket.chef.io/cookbooks/anaconda"

echo "ffs chef 12 supermarket release doesn't work; use chefdk = 0.3.6"
