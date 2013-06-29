# 
# Author: Ashish Gupta
# Date: 06/22/2013
#


require_relative 'node'

class Dictionary
    attr_accessor :start, :wordcount

    def initialize(min_word_length)
        @start = Node.new
        @wordcount = 0
        @min_word_length = min_word_length
    end

    def add_word(word)
        dist, word_added = add_chars_recursive(word.chars.to_a, @start, 0)
        @wordcount += 1 if word_added
    end

    private

    def add_chars_recursive(char_array, current_node, count)
        if char_array.empty?
            # Set the word if length is greater than minimum word length
            if count >= @min_word_length
                current_node.set_word()
                return 0, true
            else
                return 0, false
            end
        else
            if current_node.is_word? && count >= @min_word_length
                # There is already a complete word here.
                # No point adding this word
                return 0, false
            else
                char = char_array.shift
                next_node = current_node.add_next_letter(char)
                dist, word_added = add_chars_recursive(char_array, next_node, 1 + count)
                if word_added
                    distance =  dist + 1
                    current_node.add_distance(distance)
                    return distance, word_added
                else
                    return dist, word_added
                end
            end
        end       
    end
end