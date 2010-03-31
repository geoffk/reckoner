= reckoner

* http://github.com/geoffk/reckoner

== DESCRIPTION:

Ruby Reckoner is an easily-configurable program that monitors
files and can send notifications when it finds problems.

Currently it can only check that files exist, have been updated
recently and that they have a minimum size, however it is easy to add
your own checks written in Ruby.

== FEATURES/PROBLEMS:

* Easy YAML Configuration
* Check for file existence, freshness and size
* Easy to add your own checks

== USAGE:

reckoner [OPTIONS] [CONFIG FILE]

Reckoner will read its configuration information from either
the CONFIG FILE argument or from stdin.

*Options*

  -d --debug Output debugging information

  -q --quiet Suppress the check output

  -c --checks=FILE Specifies a Ruby file that contains
  additional checks that can be performed.

== REQUIREMENTS:

* Ruby

== INSTALL:

* sudo gem install reckoner

== LICENSE:

(The MIT License)

Copyright (c) 2009 Geoff Kloess

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
