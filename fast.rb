namespace :deploy do
  namespace :fast do

    desc <<-DESC
      This deploy task simply updates the code and restarts \
      the server. This does not update any gems or precompile \
      any assets because it is meant to be a deployment that takes \
      only a few seconds
    DESC
    task :default, :except => { :no_release => true } do
      run "cd #{current_path}; mv Gemfile.lock Gemfile.lock.bak; mv Gemfile Gemfile.bak"
      run "cd #{current_path}; git fetch origin; git reset --hard origin/#{branch}"
      run "cd #{current_path}; mv Gemfile.lock.bak Gemfile.lock; mv Gemfile.bak Gemfile"
      top.deploy.fast.finalize_update
      top.nginx.restart
    end

    task :finalize_update, :except => { :no_release => true } do
      run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)

      # mkdir -p is making sure that the directories are there for some SCM's that don't
      # save empty folders
      run <<-CMD
        rm -rf #{latest_release}/log #{latest_release}/public/system #{latest_release}/tmp/pids &&
        mkdir -p #{latest_release}/public &&
        mkdir -p #{latest_release}/tmp &&
        ln -s #{shared_path}/log #{latest_release}/log &&
        ln -s #{shared_path}/system #{latest_release}/public/system &&
        ln -s #{shared_path}/pids #{latest_release}/tmp/pids
      CMD

      if fetch(:normalize_asset_timestamps, true)
        stamp = Time.now.utc.strftime("%Y%m%d%H%M.%S")
        asset_paths = fetch(:public_children, %w(images stylesheets javascripts)).map { |p| "#{latest_release}/public/#{p}" }.join(" ")
        run "find #{asset_paths} -exec touch -t #{stamp} {} ';'; true", :env => { "TZ" => "UTC" }
      end
    end

  end
end