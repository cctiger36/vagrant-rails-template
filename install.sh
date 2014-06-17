#!/usr/bin/env sh

gcc 2> /dev/null

if [ $( xcode-select -p ) != "/Applications/Xcode.app/Contents/Developer" ]; then
  echo "Please install Xcode first."
  open "https://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12"
  exit 1
fi

if ! type "vagrant" > /dev/null; then
  echo "Please install Vagrant first."
  exit 1
fi

if ! vagrant plugin list | grep -q 'vagrant-berkshelf'; then
  vagrant plugin install vagrant-berkshelf --plugin-version '>= 2.0.1'
fi

if ! vagrant plugin list | grep -q 'vagrant-omnibus'; then
  vagrant plugin install vagrant-omnibus
fi

vagrant up --provision
