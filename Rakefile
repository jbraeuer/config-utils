require 'bundler'
Bundler::GemHelper.install_tasks

task :test do
  $: << 'lib'
  require 'minitest/autorun'
  require './lib/config-utils'
  Dir['./test/**/test_*.rb'].each { |test| require test }
end
