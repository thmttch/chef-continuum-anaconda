#!/usr/bin/env bash

echo "Don't know how to automate this (creds), so here are the instructions:"
echo ""

echo 'BUMP METADATA.RB!!!! stop forgetting this'
echo ""

echo 'cut a github release, checkout that tag, then run the next command:'
echo ""

echo 'knife cookbook site share anaconda "Programming Languages" --cookbook-path PATH --config KNIFE.RB/${CHEF_PUB}'
echo ""

echo "https://docs.getchef.com/knife_cookbook_site.html#share"
