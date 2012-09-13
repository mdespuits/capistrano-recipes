set_default :memcached_memory_limit, 64
set_default :memcached_log_file, "/var/log/memcached.log"

namespace :memcached do
  desc "Install Memcached"
  task :install, roles: :app do
    run "#{sudo} apt-get -y install memcached"
  end
  after "deploy:install", "memcached:install"

  desc "Setup Memcached"
  task :setup, roles: :app do
    template "memcached.erb", "/tmp/memcached.conf"
    run "#{sudo} mv /tmp/memcached.conf /etc/memcached.conf"
    restart
  end
  after "deploy:setup", "memcached:setup"

  %w[start stop restart].each do |command|
    desc "#{command} Memcached"
    task command, roles: :app do
      run "#{sudo} service memcached #{command}"
    end
  end
end
