#!/usr/bin/env sh

if ! type "vagrant" > /dev/null; then
  echo "Please install Vagrant first."
  exit 1
fi

if ! vagrant plugin list | grep -q 'vagrant-berkshelf'; then
  vagrant plugin install vagrant-berkshelf
fi

if ! vagrant plugin list | grep -q 'vagrant-omnibus'; then
  vagrant plugin install vagrant-omnibus
fi

vagrant up --provision
