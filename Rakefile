require 'bundler'
Bundler::GemHelper.install_tasks

task :test do
  $: << 'lib'
  require 'minitest/autorun'
  require 'n4env'
  Dir['./test/**/test_*.rb'].each { |test| require test }
end
