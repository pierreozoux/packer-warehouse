#!/bin/bash -eux

GEM=/opt/ruby/bin/gem

# Add puppet user and group
adduser --system --group --home /var/lib/puppet puppet

# Installing Puppet
if [ -z "$PUPPET_VERSION" ]; then
  # Default to latest
  $GEM install puppet --no-ri --no-rdoc
else
  $GEM install puppet --no-ri --no-rdoc --version $PUPPET_VERSION
fi
