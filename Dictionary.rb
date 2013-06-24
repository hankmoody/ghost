# 
# Author: Ashish Gupta
# Date: 06/22/2013
#

require_relative 'node'

class Dictionary
    attr_accessor :start, :wordcount

    def initialize
        @start = Node.new
        @wordcount = 0
    end

    def add_word(word)
        add_chars_recursive(word.chars.to_a, @start)
        @wordcount += 1
    end

    private

    def add_chars_recursive(char_array, current_node)
        distance = 0
        char = char_array.shift
        next_node = current_node.add_next_letter(char)
        if char_array.empty?
            next_node.set_word()
            distance = 0
        else
            distance = add_chars_recursive(char_array, next_node) + 1
            current_node.add_distance(distance)
        end
        return distance
    end
end