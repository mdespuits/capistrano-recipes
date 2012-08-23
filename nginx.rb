set_default(:nginx_port, 80)
set_default(:nginx_error_pages, true)
set_default(:nginx_chrome_frame, true)

namespace :nginx do
  desc "Install latest stable release of nginx"
  task :install, roles: :web do
    run "#{sudo} add-apt-repository ppa:nginx/stable"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install nginx"
  end
  after "deploy:install", "nginx:install"

  desc "Setup nginx configuration for this application"
  task :setup, roles: :web do
    template "nginx.conf.erb", "/tmp/nginx_conf"
    run "#{sudo} mkdir -p #{shared_path}/config"
    run "#{sudo} cp /tmp/nginx_conf #{shared_path}/config/nginx.conf"
    run "#{sudo} mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{application}"
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
  end
  after "deploy:setup", "nginx:setup"

  %w[start stop].each do |command|
    desc "#{command} nginx"
    task command, roles: :web do
      run "#{sudo} service nginx #{command}"
    end
    after "deploy:#{command}", "nginx:#{command}"
  end

  desc "Restart nginx"
  task :restart, roles: :web do
    run "#{sudo} service nginx restart"
  end
end
