
require 'rubygems'
require 'cucumber/rake/task'

require 'rake'
require 'spec/rake/spectask'

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*.rb']
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
  t.rcov_opts << %[-o "features/cucumber"]
end

task :doc do |t|
  `rdoc -d src/ -o doc/api -U`
end

task :default => [:spec, :features, :verify_rcov]
