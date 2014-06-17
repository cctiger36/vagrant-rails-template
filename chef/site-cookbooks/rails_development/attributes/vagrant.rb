default['project']['user'] = "vagrant"
default['project']['group'] = "vagrant"
default['project']['email'] = "EMAIL"
default['project']['home'] = "/home/vagrant"
default['project']['trust_local_sshkeys'] = "yes"

default['project']['app_home'] = "/vagrant/APP_NAME"
default['project']['git_url'] = "GIT_URL"
default['project']['git_branch'] = "master"
default['project']['gemset'] = "GEMSET_NAME"

default['project']['packages'] = %w[curl memcached redis-server imagemagick libxslt-dev libxml2-dev build-essential libmagickwand-dev vim]
default['project']['databases'] = %w[DATABASE_NAMES]

default['project']['ruby_version'] = "2.1.2"
