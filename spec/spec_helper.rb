require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../..', 'lib'))

require 'fakefs/safe'

require 'git_test'
require 'rspec'


# https://github.com/defunkt/fakefs
# https://github.com/visionmedia/terminal-table