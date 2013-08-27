#!/bin/bash -eux

GEM=/opt/ruby/bin/gem

# Installing chef Using gems
if [ -z "$CHEF_VERSION" ]; then
  # Default to latest
  $GEM install chef --no-ri --no-rdoc
else
  $GEM install chef --no-ri --no-rdoc --version $CHEF_VERSION
fi
