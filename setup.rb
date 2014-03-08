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

class Display
public
	# Takes the message and displays it while also throwing it into a file
	# 					/- How many items we will be using.
	# 					| 				/- How deep are we
	def initialize(total_items = 1, level = 0)
		@level = level
		@total_items = total_items - 1
		@current_item = 0
	end

	# Takes the message and displays it while also throwing it into a file
	# 				/- The message you want to display
	# 				|
	def display(message)
		# What we are up to, formatted like [2/5] meaning up to the 2nd step.
		# out of 6 steps. Steps start at 0
		progress = "[" + @current_item.to_s + "/" + @total_items.to_s + "]"

		# How much padding to use, helps keeping track visually with levels.
		padding = ' ' * @level

		# The tracer for added visual flair for the user to see what level
		# we are in.
		if @level != 0
			if @current_item == 0 .. @total_items - 1 then tracer = '|- ' end
			if @current_item == @total_items then tracer = '\- ' end
			if @current_item > @total_items then tracer = '?  ' end
		elsif @level == 0
			tracer = ""
		end
		
		# Display the string in question with progress
		if @total_items == 0
			puts padding + tracer + message
		else
			puts padding + tracer +  progress + " " + message
		end

		# Generates a new Logger object for logging to file.
		logger = Log4r::Logger.new( 'Doge_Personal_Picaxe' )

		# Save to the app name logfile.
		logger.outputters << Log4r::FileOutputter.new( 
			'Doge_Personal_Picaxe', 
			:filename => 'Doge_Personal_Picaxe.log' )

		# Throw the string in question into the logfile.
		logger.info message

		# Increment the current item to the next one once we are done.
		@current_item = @current_item.next
	end

	# If for whatever reason the user wants to know current progress.
	attr_reader :current_item
	attr_reader :total_items

	# I don't think I need the ruby version of a destructor.
	
private
	# Seems we don't need any private class stuff!
end
