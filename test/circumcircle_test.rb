require_relative 'test_helper'
require_relative '../library/geometry/lib/point.rb'
require_relative '../library/geometry/lib/circumcircle.rb'

class PointTest < Minitest::Test
  attr_reader :circumcircle
  def setup
    a = Point.new
    b = Point.new 10, 0
    c = Point.new 5, 10
    @circumcircle = Circumcircle.new(a, b, c)
  end

  def test_point
    assert_instance_of Circumcircle, circumcircle
  end

  def test_point_inside
    ipoint = Point.new(1, 1)
    opoint = Point.new(1, 15)
    assert circumcircle.inside?(ipoint)
    refute circumcircle.inside?(opoint)
  end
end
