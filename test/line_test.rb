require_relative 'test_helper'
require_relative '../library/geometry/lib/vec2d'
require_relative '../library/geometry/lib/point'
require_relative '../library/geometry/lib/line'

class LineTest < Minitest::Test
  attr_reader :line, :line2
  def setup
    a = Point.new
    b = Point.new 100, 100
    c = Point.new -50, 50
    d = Point.new 50, -50
    @line = Line.new a, b
    @line2 = Line.new c, d
  end

  def test_line
    assert_instance_of Line, line
  end

  def test_line_contains?
    assert line.contains?(Point.new(50, 50))
    refute line.contains?(Point.new(15, 5))
  end

  def test_line_cross?
    assert line.cross?(line2)
  end

  def test_intersect_instance
    assert_instance_of Point, line.intersect(line2)
  end

  def test_vector_instance
    assert_instance_of Vec2D, line.vector
  end
end
