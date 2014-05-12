require "bundler/gem_tasks"
require "rake/testtask"

desc "Run tests"
Rake::TestTask.new(:test) do |t|
  t.libs.push 'lib'
  t.test_files = FileList['spec/**/*_spec.rb']
  t.verbose = true
end

task :spec => [:test]

desc "Start a console"
task :console do
  exec "irb -I lib -r './lib/accumulo_visibility_parser.rb' -r 'irb/completion'"
end
