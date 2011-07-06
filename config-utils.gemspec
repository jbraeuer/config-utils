Gem::Specification.new do |s|
  s.name = 'config-utils'
  s.version = "0.1.1"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Braeuer"]
  s.summary = "Configuration utils"
  s.description = "Configuration utils."
  s.email = %q{jens@numberfour.com}
  s.files = `git ls-files`.split("\n")
  s.rubyforge_project = "unknown"
  s.homepage = %q{http://www.numberfour.eu}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.test_files = `git ls-files`.split("\n").select{|f| f =~ /^spec/}
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  # dependencies
  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'gitstore'
  s.add_runtime_dependency 'grit'
end
