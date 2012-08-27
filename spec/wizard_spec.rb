require 'spec_helper'
require 'fakefs/safe'

require 'commander'

require File.dirname(__FILE__) + '/../lib/migration'
require File.dirname(__FILE__) + '/../lib/wizard'

module Rails
  def self.root
    File.dirname(__FILE__) + '/data'
  end
end

describe MigrationReorderTask::Wizard do

  let(:files) do
    [
      'data/db/migrate/20111224143734_another_thing.rb',
      'data/db/migrate/20120808030100_yet_another_thing.rb',
      'data/db/migrate/20120820231450_create_thing.rb',
      'data/db/migrate/20120820231455_add_other_thing.rb']
  end

  let(:wizard) { MigrationReorderTask::Wizard.new() }

  let!(:stdout) { StringIO.new }
  let!(:stdin) { StringIO.new }

  context "#pick_migration" do
    before do
      $terminal = HighLine.new(stdin, stdout)
      FakeFS.activate!
      FakeFS::FileSystem.clone(File.dirname(__FILE__))
    end

    it "should list all shortnames except for last one" do
      stdin << "2\n"
      stdin.rewind
      wizard.pick_migration
      lines = stdout.string.split("\n")
      lines[0].should =~ /Pick a migration/
      lines[1].should == "1. another_thing"
      lines[2].should == "2. yet_another_thing"
      lines[3].should == "3. create_thing"
      lines[4].should == "?  "
    end

    it "should move migration when user selects yes" do
      stdin << "2\n"
      stdin.rewind
      wizard.pick_migration
      stdin.truncate(stdin.rewind)
      stdout.truncate(stdout.rewind)
      wizard.move_migration
      #MigrationReorderTask::Wizard.any_instance.stub(:system)
      stdout.string.should =~ \
        %r{git mv.*data/db/migrate/20120808030100_yet_another_thing.rb.*data/db/migrate/20120820231456_yet_another_thing.rb}
      #File.exists?(File.dirname(__FILE__) + 'data/db/migrate/20120820231456_yet_another_thing.rb').should be_true
    end

    after do
      FakeFS.deactivate!
    end
  end
end
