define :bundle_exec, command: nil do
  bundle_command = params[:command]
  user_execute params[:name] do
    command "cd #{node['project']['app_home']}; rvm #{node['project']['ruby_version']} exec bundle exec -- #{bundle_command}"
  end
end
