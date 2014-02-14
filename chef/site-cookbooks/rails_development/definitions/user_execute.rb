define :user_execute, command: nil do
  execute params[:name] do
    command "su #{node['project']['user']} -l -c '#{params[:command]}'"
    not_if "su #{node['project']['user']} -l -c '#{params[:not_if]}'" if params[:not_if]
  end
end
