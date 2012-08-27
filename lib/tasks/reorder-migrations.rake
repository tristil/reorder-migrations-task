namespace :db do
  namespace :migrate do
    desc "Reorder migrations when they get out of sync"
    task :reorder => :environment do
      MigrationReorderTask::Wizard.start
    end
  end
end
