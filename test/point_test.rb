require_relative 'test_helper'
require_relative '../library/geometry/lib/circumcircle.rb'
require_relative '../library/geometry/lib/point.rb'

class PointTest < Minitest::Test
  attr_reader :a, :b, :c
  def setup
    @a = Point.new
    @b = Point.new 10, 0
    @c = Point.new 5, 10
  end

  def test_point
    assert_instance_of Point, a
  end

  def test_point_distance_squared
    dpoint = Point.new(1, 1)
    assert_in_delta 2, a.distance_squared(dpoint)
  end

  def test_point_in_circumcircle?
    ipoint = Point.new(1, 1)
    opoint = Point.new(1, 15)
    assert ipoint.in_circumcircle?(a, b, c)
    refute opoint.in_circumcircle?(a, b, c)
  end
end
