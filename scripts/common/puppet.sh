#!/bin/bash -eux

GEM=/opt/ruby/bin/gem

# Installing Puppet
if [ -z "$PUPPET_VERSION" ]; then
  # Default to latest
  $GEM install puppet --no-ri --no-rdoc
else
  $GEM install puppet --no-ri --no-rdoc --version $PUPPET_VERSION
fi
