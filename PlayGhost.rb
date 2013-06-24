# 
# Author: Ashish Gupta
# Date: 06/22/2013
#

require_relative 'ghost'

def load_word_list
    print "Loading Dictionary..."
    dict = Dictionary.new
    IO.foreach("WORD.LST", sep="\n") do |word|
        dict.add_word(word.chomp) unless word.empty?
    end
    puts "done!"
    print "Dictionary loaded with ", dict.wordcount, " words.\n"
    return dict
end

#
# Main
#

# Load dictionary in memory
dict = load_word_list()

# Start the game
game = Ghost.new(dict)

begin
    game.play
    print "\n\tPlay again? [y/n]: "
    play_again = get_character
    print "\n"
end while play_again.chr.eql?('y') || play_again.chr.eql?('Y')

puts "\n\tThanks for playing!"

