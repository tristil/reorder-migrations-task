# What is it?

This gem adds a drop-in task for Rails that allows you to perform the rare but
mildly annoying task of having to renumber your migration files. This can
occur, for example, when a feature branch hits master containing migrations
that are dated *after* the migration files in your on-going feature branch. The
agony, right?

# Caveats

* Assumes you use Git
* At present only supports the simple case of wanting to advance a migration
  beyond the last dated migration file.

# Usage

* `rake db:migrate:reorder`
