require 'talks'

namespace :talks do

  desc "Announce when deployment is complete"
  task :deploy_finish, roles: :web do
    Talks.say "Sir, your deployment was successful."
  end
  after "deploy:cleanup", "talks:deploy_finish"

  desc "Announce when deployment rollsback"
  task :deploy_rollback, roles: :web do
    Talks.say "Sir, your deployment failed."
  end
  after "deploy:rollback", "talks:deploy_rollback"

end
