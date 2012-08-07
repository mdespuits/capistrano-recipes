set_default(:puma_user) { user }
set_default(:puma_min_threads) { 1 }
set_default(:puma_max_threads) { 16 }
set_default(:puma_port) { "80" }
set_default(:puma_bind) { "tcp://0.0.0.0:#{puma_port}" }
set_default(:puma_pid) { "#{shared_path}/pids/puma.pid" }

namespace :puma do
  desc "Start Puma"
  task :start, :except => { :no_release => true } do
    commands = ["cd #{current_path};"]
    commands << ["bundle exec puma"]
    commands << ["--environment production"]
    commands << ["--pidfile #{puma_pid}"]
    commands << ["--threads #{puma_min_threads}:#{puma_max_threads}"]
    begin
      commands << "--bind #{puma_bind}"
    rescue; end
    run commands.join(" "), :pty => false
  end
  after "deploy:start", "puma:start"

  desc "Stop Puma"
  task :stop, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{puma_pid}`"
  end
  after "deploy:stop", "puma:stop"

  desc "Restart Puma"
  task :restart, roles: :app do
    run "kill -s SIGUSR2 `cat #{puma_pid}`"
  end
  after "deploy:restart", "puma:restart"
end
