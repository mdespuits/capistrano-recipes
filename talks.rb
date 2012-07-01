require 'talks'

namespace :talks do

  desc "Announce when deployment is complete"
  task :deploy_finish, roles: :web do
    Talks.say "Master, the application #{application} was successfully deployed."
  end
  after "deploy:cleanup", "talks:deploy_finish"

  desc "Announce when deployment rollsback"
  task :deploy_rollback, roles: :web do
    Talks.say "Master, the application #{application} failed to deploy."
  end
  after "deploy:rollback", "talks:deploy_rollback"

end
