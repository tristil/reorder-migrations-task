require 'spec_helper'
require File.dirname(__FILE__) + '/../lib/migration'

describe MigrationReorderTask::Migration do
  let(:filename) { 'data/20120820231450_create_thing.rb' }
  let(:migration) { MigrationReorderTask::Migration.new(filename)  }

  it "parses the datestamp" do
    migration.datestamp.should == '20120820231450'
  end

  it "parses the shortname" do
    migration.shortname.should == 'create_thing'
  end

  context "#move_ahead_of" do
    let(:last_migration_filename) { 'data/20120820231455_add_other_thing.rb' }
    let(:last_migration) { MigrationReorderTask::Migration.new(last_migration_filename)  }
    before { migration.move_ahead_of(last_migration) }

    it "sets the old file" do
      migration.old_file.should == File.expand_path(filename)
    end

    it "sets file to the incremented value" do
      migration.file.should == File.expand_path('data/20120820231456_create_thing.rb')
    end
  end
end
