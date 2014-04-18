#!/usr/bin/env bash

echo Setting up Ruby environment
apt-get update > /dev/null 2>&1
echo Installing curl
apt-get install -y curl > /dev/null 2>&1
echo Installing git
apt-get install -y git > /dev/null 2>&1
echo Downloading and Installing RVM
curl -L https://get.rvm.io | bash -s stable --ruby > /dev/null
source /usr/local/rvm/scripts/rvm
echo "We want a Ruby version >2.0"
echo `ruby -v`
cd /vagrant
echo Installing bundler gem
gem install bundler
echo Installing rake gem
gem install rake
#echo Cloning Petfinder gem
#git clone https://github.com/TeamDogFace/Petfinder
#cd Petfinder
#bundle install
#rake install petfinder.gemspec

