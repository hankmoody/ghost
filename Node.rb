# 
# Author: Ashish Gupta
# Date: 06/22/2013
#

class NodeBase
    attr_accessor :letter, :nodes, :is_word

    def initialize(letter = "")
        @letter = letter
        @nodes = Hash.new
        @is_word = false
    end

    def add_next_letter(letter)
        letter_symbol = letter.to_sym
        @nodes[letter_symbol] = Node.new(letter) unless @nodes.has_key?(letter_symbol)
        return @nodes[letter_symbol]
    end

    def is_next_letter?(letter)
        @nodes.has_key?(letter.to_sym)
    end

    def get_next_node(letter)
        return nil if !is_next_letter?(letter)
        return @nodes[letter.to_sym]
    end

    def set_word
        @is_word = true
    end

    def is_word?
        @is_word
    end
end

class Node < NodeBase
    attr_accessor :even_distance, :odd_distance

    def initialize(letter = "")
        super(letter)
        @even_distance = 0
        @odd_distance = 0
    end

    def add_distance(dist)
        if dist % 2 == 0
            @even_distance += 1
        else
            @odd_distance += 1
        end
    end

    def is_pure_even
        return even_distance > 0 && odd_distance == 0
    end

    def is_pure_odd
        return odd_distance > 0 && even_distance == 0
    end

    def find_optimal_move
        pure_evens = Array.new
        pure_odds = Array.new
        mixed = Array.new
        will_word = Array.new

        @nodes.keys.each do |key|
            if !@nodes[key].is_word
                if @nodes[key].is_pure_even
                    pure_evens.push key
                elsif @nodes[key].is_pure_odd
                    pure_odds.push key
                else
                    mixed.push key
                end
            else
                will_word.push key
            end
        end

        if !pure_evens.empty?
            # Winning move. Return a random symbol from here
            r = rand (pure_evens.length - 1)
            return pure_evens[r]
        end

        if !mixed.empty?
            # It could go either way. Return a random symbol from here
            r = rand (mixed.length - 1)
            return mixed[r]
        end

        if !pure_odds.empty?
            # Losing move. Return symbol with the highest odd value.
            max_odd = pure_odds.first
            pure_odds.each do |k|
                max_odd = k if @nodes[k].odd_distance > @nodes[max_odd].odd_distance
            end
            return max_odd
        end

        if !will_word.empty?
            # Losing move. Return a random symbol
            r = rand (will_word.length - 1)
            return will_word[r]
        end
    end 
end