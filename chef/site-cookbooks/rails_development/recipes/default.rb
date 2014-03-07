node['project']['packages'].each do |package_name|
  package package_name do
    action :install
  end
end

user_execute "install rvm" do
  command "curl -sSL https://get.rvm.io | bash -s stable; source #{node['project']['home']}/.rvm/scripts/rvm"
  not_if { ::File.exists? "#{node['project']['home']}/.rvm" }
end

user_execute "install and setup ruby" do
  command "rvm install #{node['project']['ruby_version']}; rvm use #{node['project']['ruby_version']}; rvm gemset create #{node['project']['gemset']}; rvm use #{node['project']['ruby_version']}@project --default"
  not_if "rvm list | grep -q '#{node['project']['ruby_version']}'"
end

service "memcached" do
  action [:enable, :start]
end

service "redis-server" do
  action [:enable, :start]
end

directory "#{node['project']['home']}/.ssh" do
  owner node['project']['user']
  group node['project']['group']
  mode 0700
end

template "#{node['project']['home']}/.ssh/config" do
  source "ssh_config.erb"
  owner node['project']['user']
  group node['project']['group']
  mode 0644
  variables(
    trust_local_sshkeys: node['project']['trust_local_sshkeys'],
    git_username: node['project']['host_username']
  )
end

file "#{node['project']['home']}/.ssh/id_rsa" do
  owner node['project']['user']
  group node['project']['group']
  mode 0600
  content node['project']['id_rsa']
end

file "#{node['project']['home']}/.ssh/id_rsa.pub" do
  owner node['project']['user']
  group node['project']['group']
  mode 0644
  content node['project']['id_rsa_pub']
end

execute "git-config for vagrant" do
  command "sudo -u vagrant -H git config --global user.name '#{node['project']['host_username']}'; sudo -u vagrant -H git config --global user.email '#{node['project']['host_username']}@drecom.co.jp'"
end

node['project']['databases'].each do |database|
  mysql_database database do
    connection(
      host: 'localhost',
      username: 'root',
      password: node['mysql']['server_root_password']
    )
    encoding "utf8"
    action :create
  end
end

git node['project']['app_home'] do
  repository node['project']['git_url']
  reference node['project']['git_branch']
  action :checkout
  user node['project']['user']
  timeout 3600
  not_if "ls #{node['project']['app_home']}/.git"
end

user_execute "bundle install" do
  command "cd #{node['project']['app_home']}; rvm #{node['project']['ruby_version']}@project exec bundle"
end

bundle_exec "migrate" do
  command "rake db:migrate"
end

bundle_exec "seed" do
  command "rake db:seed"
end
