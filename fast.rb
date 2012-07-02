namespace :deploy do

  desc <<-DESC
    This deploy task simply updates the code and restarts \
    the server. This does not update any gems or precompile \
    any assets because it is meant to be a deployment that takes \
    only a few seconds
  DESC
  task :fast, :except => { :no_release => true } do
    run "cd #{current_path}; mv Gemfile.lock Gemfile.lock.bak; mv Gemfile Gemfile.bak"
    run "cd #{current_path}; git fetch origin; git reset --hard origin/#{branch}"
    run "cd #{current_path}; mv Gemfile.lock.bak Gemfile.lock; mv Gemfile.bak Gemfile"
    finalize_update
    restart
  end

end
