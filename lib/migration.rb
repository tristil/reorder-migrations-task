module MigrationReorderTask; end

class MigrationReorderTask::Migration
  DS = File::SEPARATOR

  attr_reader :file, :old_file

  def initialize file
    file = File.expand_path(file)
    @old_file, @file = file, file
  end

  def datestamp
    File.basename(@file).match(/^(\d+?)_/)[1]
  end

  def shortname
    File.basename(@file).gsub('.rb','').gsub(/^\d+?_/, '')
  end

  def move_ahead_of(target_migration)
    @old_file = @file
    new_datestamp = target_migration.datestamp.to_i + 1
    new_file = File.dirname(@file) + DS + new_datestamp.to_s + '_' + shortname + '.rb'
    @file = new_file
  end
end

