#!/bin/bash -eux

cd /tmp

wget http://pyyaml.org/download/libyaml/yaml-$LIBYAML_VERSION.tar.gz
tar xvzf yaml-$LIBYAML_VERSION.tar.gz
cd yaml-$LIBYAML_VERSION
./configure --prefix=/usr/local
make && make install
cd ..
rm -rf yaml-$LIBYAML_VERSION
rm yaml-$LIBYAML_VERSION.tar.gz

wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-$RUBY_VERSION.tar.gz
tar xvzf ruby-$RUBY_VERSION.tar.gz
cd ruby-$RUBY_VERSION
./configure --prefix=/opt/ruby --enable-shared --disable-install-doc --with-opt-dir=/usr/local/lib
make && make install
cd ..
rm -rf ruby-$RUBY_VERSION
rm ruby-$RUBY_VERSION.tar.gz

echo 'PATH=$PATH:/opt/ruby/bin/' > /etc/profile.d/vagrantruby.sh
