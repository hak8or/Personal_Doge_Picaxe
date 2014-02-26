#!/usr/bin/env ruby

require 'log4r'
include Log4r

BEGIN{
puts <<"block_of_text";
	+----------------------------------------------------+
	|     Sets up a P2P mining node for you locally!     |
	|                                                    |
	|                                                    |
	| Sit back, grab a cup of tea, and relax as I take   |
	| care of everything for you while you are watch in  |
	| awe at the minutes of setting up and confusion are |
	| shortened to mere minutes!                         |
	|                                                    |
	+----------------------------------------------------+
block_of_text
}

# create a logger named 'mylog' that logs to stdout
mylog = Logger.new 'mylog'
mylog.outputters = Outputter.stdout

# Now we can log.
def do_log(log)
  log.debug "This is a message with level DEBUG"
  log.info "This is a message with level INFO"
  log.warn "This is a message with level WARN"
  log.error "This is a message with level ERROR"
  log.fatal "This is a message with level FATAL"
end
do_log(mylog)
