module MigrationReorderTask; end

class MigrationReorderTask::Wizard

  def self.start
    require 'commander'

    while true
      wizard = self.new
      wizard.run
    end
  end

  def run
    pick_migration
    agreed = warn_user
    move_migration if agreed
    ask_about_restart
  end

  def pick_migration
    say bold("Pick a migration to move to the end")
    menu_items = recent_migrations.collect {|m| m.shortname }
    choice = choose(*menu_items)
    @migration = recent_migrations.select {|m| m.shortname == choice }.first
  end

  def warn_user
    agree "Do you want to move #{bold(@migration.shortname)} ahead of #{bold(last_migration.shortname)} (Y/N)?"
  end

  def move_migration
    @migration.move_ahead_of(last_migration)
    system("git", "mv", @migration.old_file, @migration.file)
    say "git mv #{@migration.old_file} #{@migration.file}"
  end

  def ask_about_restart
    exit unless agree "Reorder another migration? (Y/N)?"
  end

  def last_migration
    migrations.last
  end

  def recent_migrations
    start_with = migrations.length > 10 ? -10 : 0
    migrations[start_with..-2]
  end

  def migrations
    @migrations||= Dir[Rails.root.to_s + '/db/migrate/*'].collect do |file|
      MigrationReorderTask::Migration.new(file)
    end
  end

  private

  def bold text
    HighLine::color(text, HighLine::BOLD)
  end
end

