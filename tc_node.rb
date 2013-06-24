# 
# Author: Ashish Gupta
# Date: 06/22/2013
#
#
# Unit test for NodeBase class
#

require_relative 'node'
require 'test/unit'

class TestNodeBase < Test::Unit::TestCase

    def test_create1
        assert_not_nil(NodeBase.new, "Create a new NodeBase object")
    end

    def test_create2
        n = NodeBase.new("a")
        assert_equal("a", n.letter)
    end

    def test_add_next_letter
        n = NodeBase.new("a")
        child = n.add_next_letter("n")
        
        assert_equal("n", child.letter)
        assert_equal(true, n.is_next_letter?("n"))
        assert_not_equal(true, n.is_next_letter?("b"))
        
        assert_not_nil(n.get_next_node("n"))
        assert_nil(n.get_next_node("b"))

        assert_not_equal(true, child.is_word?)
        child.set_word
        assert_equal(true, child.is_word?)
    end
end


class TestNode < Test::Unit::TestCase

    def test_even_distance
        n = Node.new("a")

        n.add_distance(2)
        assert_equal(1, n.even_distance)
        assert_equal(true, n.is_pure_even)
        assert_equal(false, n.is_pure_odd)

        n.add_distance(4)
        assert_equal(2, n.even_distance)
        assert_equal(true, n.is_pure_even)
        assert_equal(false, n.is_pure_odd)

        n.add_distance(5)
        assert_equal(2, n.even_distance)
        assert_equal(1, n.odd_distance)
        assert_equal(false, n.is_pure_even)
        assert_equal(false, n.is_pure_odd)
    end

    def test_odd_distance
        n = Node.new("a")

        n.add_distance(1)
        assert_equal(1, n.odd_distance)
        assert_equal(true, n.is_pure_odd)
        assert_equal(false, n.is_pure_even)

        n.add_distance(3)
        assert_equal(2, n.odd_distance)
        assert_equal(true, n.is_pure_odd)
        assert_equal(false, n.is_pure_even)

        n.add_distance(2)
        assert_equal(1, n.even_distance)
        assert_equal(2, n.odd_distance)
        assert_equal(false, n.is_pure_even)
        assert_equal(false, n.is_pure_odd)
    end
end
