require 'rake'
require 'lib/main.rb'

spec = Gem::Specification.new do |s|
  s.name = 'reckoner'
  s.version = Main::VERSION
  s.summary = 'Checks user-specified files and sends alert emails when not found.'
  s.authors = 'Geoff Kloess'
  s.email = 'geoff.kloess@gmail.com'
  s.homepage = 'http://github.com/geoffk/reckoner'
  s.add_dependency('mail')
  s.files = FileList['Gemfile','History.txt','README.txt','bin/*','lib/*']
  s.executables = 'reckoner'

  s.description = <<-EOF
Ruby Reckoner is an easily-configurable program that monitors
files and can send notifications when it finds problems.

Currently it can only check that files exist, have been updated
recently and that they have a minimum size, however it is easy to add
your own checks written in Ruby.
  EOF

end

