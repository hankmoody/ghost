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
    attr_accessor :even_distance, :odd_distance, :furthest_word

    def initialize(letter = "")
        super(letter)
        @even_distance = 0
        @odd_distance = 0
        @furthest_word = nil
    end

    def add_distance(dist)
        if dist % 2 == 0
            @even_distance += 1
        else
            @odd_distance += 1
        end
        @furthest_word = dist if (@furthest_word.nil? || @furthest_word < dist)
    end

    def is_pure_even
        return even_distance > 0 && odd_distance == 0
    end

    def is_pure_odd
        return odd_distance > 0 && even_distance == 0
    end

    def has_child_words?
        return (odd_distance + even_distance) > 0
    end

    def to_s
        "#{@letter}-#{@even_distance}-#{odd_distance}-#{furthest_word}"
    end

    def find_optimal_move
        d = get_decision_hash

        if !d[:odds].empty?
            # Winning move. Return a random symbol from here
            r = rand (d[:odds].length - 1)
            return d[:odds][r]
        end

        if !d[:mixed].empty?
            # Find the longest word
            ret = d[:mixed].first
            d[:mixed].each do |n|
                ret = n if n.furthest_word > ret.furthest_word
            end
            return ret               
        end

        if !d[:evens].empty?
            # Find the longest word
            ret = d[:evens].first
            d[:evens].each do |n|
                ret = n if n.furthest_word > n.furthest_word
            end
            return ret          
        end

        if !d[:partials].empty?
            # Losing move. Return a random symbol
            r = rand (d[:partials].length - 1)
            return d[:partials][r]
        end

        if !d[:words].empty?
            # Losing move. Return a random symbol
            r = rand (d[:words].length - 1)
            return d[:words][r]
        end
    end 

    private

    def get_decision_hash 
        pure_evens = Array.new
        pure_odds = Array.new
        mixed = Array.new
        will_word = Array.new
        partials = Array.new

        @nodes.each do |key, n|
            if !n.is_word?
                if n.has_child_words?
                    if n.is_pure_even
                        pure_evens.push n
                    elsif n.is_pure_odd
                        pure_odds.push n
                    else
                        mixed.push n
                    end
                else
                    partials.push n
                end
            else
                will_word.push n
            end
        end 

        decision_hash = {
            :evens => pure_evens,
            :odds => pure_odds,
            :mixed => mixed,
            :words => will_word,
            :partials => partials
        }
        return decision_hash
    end
end