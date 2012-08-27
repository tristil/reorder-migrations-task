Gem::Specification.new do |s|
  s.name        = 'reorder-migrations-task'
  s.version     = '0.0.1'
  s.date        = '2012-08-26'
  s.summary     = 'Simple CLI tool for reordering Rails migration files'
  s.description = <<-EOF
Simple CLI tool for reordering Rails migrations when they get out of sync, for
example when a feature branch gets merged into master ahead of your code.
EOF
  s.authors     = ["Joseph Method"]
  s.email       = 'jmethod@wegowise.com'
  s.files         = `git ls-files`.split("\n")
  s.homepage    = 'http://rubygems.org/gems/reorder-migrations-task'
  s.require_paths = ['lib']
  s.add_dependency 'commander', '~> 4.1.2'
end
