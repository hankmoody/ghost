# 
# Author: Ashish Gupta
# Date: 06/22/2013
#

begin
	gem 'highline'	
rescue LoadError
	system("gem install highline")
	Gem.clear_paths
end

require 'rubygems'
require 'highline/system_extensions'
include HighLine::SystemExtensions
require_relative 'dictionary'

class Ghost
	attr_accessor :dictionary, :current_node, :count, :current_word

	def initialize(dict)
		@dictionary = dict
		@current_node = @dictionary.start
		@current_word = ""
	end

	def play
		@count = 0
		@current_node = @dictionary.start
		@current_word = ""
		loop do
			c = get_char_from_player()
			break if !validate_player_input(c)
			add_character(c.chr)
			play_computers_turn
			break if !validate_computer_input
			print "\n"
		end	
		print "\n"
	end

	private

	MIN_LETTER_COUNT = 4

	def get_char_from_player
		print "\n\tYou => "
		c = get_character
		print_current_word(c.chr)
		return c
	end

	def validate_player_input(c)
		return 	is_valid_ascii_char?(c) && 
				will_make_invalid_word?(c.chr) && 
				will_make_complete_word?(c.chr) &&
				has_future_words?(c.chr)
	end


	def is_valid_ascii_char?(c)
		if  !c.between?(65,90) && !c.between?(97,122)
			print " character not recognized! Aborting..."
			return false
		end
		return true
	end

	def will_make_invalid_word?(char)		
		if !@current_node.is_next_letter?(char)
			print " is an invalid word! You Lose!"
			return false
		end
		return true
	end

	def will_make_complete_word?(char)
		next_node = @current_node.get_next_node(char)
		if contains_complete_word?(next_node, @count + 1)
			print " is a valid word! You Lose!"
			return false
		end
		return true
	end

	def has_future_words?(char)
		if @current_node.get_next_node(char).nodes.empty?
			print " ...no more letters left to form a word"
			return false
		end
		return true
	end

	def contains_complete_word?(node, count)
		if node.is_word? && count > MIN_LETTER_COUNT
			return true
		end
		return false
	end

	def add_character(char)
		@current_node = @current_node.get_next_node(char)
		@current_word += char
		@count += 1
	end

	def play_computers_turn
		char_to_play = @current_node.find_optimal_move.to_s
		add_character(char_to_play)
		print "\n\tComputer => "
		print_current_word
	end

	def validate_computer_input
		if contains_complete_word?(@current_node, @count)
			print "\n\n\tCongratulations! You won!\n"
			return false
		end

		if @count <= MIN_LETTER_COUNT && @current_node.nodes.empty?
			print " ...no more letters left to form a word"
			return false
		end
		return true
	end

	def print_current_word(optional_char = "")
		print "[", @current_word, optional_char, "]"
	end

end

