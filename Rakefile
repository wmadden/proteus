
require 'rubygems'
require 'cucumber/rake/task'

require 'rake'
require 'spec/rake/spectask'

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['test/spec/**/*.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
  t.rcov_dir = 'coverage/spec/'
end

require 'spec/rake/verify_rcov'

RCov::VerifyTask.new(:verify_rcov => :spec) do |t|
  t.threshold = 100.0
  t.index_html = 'coverage/spec/verify/index.html'
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty"
  t.rcov = true
  t.rcov_opts << %[-o "test/features/cucumber"]
end

task :doc do |t|
  `rdoc -aUd src/ -o doc/api`
end

task :install do
  `cp -R lib /usr/lib/ruby/gems/1.8/gems/proteus-0.9.0/`
end

task :default => [:spec, :features, :verify_rcov]
