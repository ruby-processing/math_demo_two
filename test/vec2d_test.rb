require 'propane'
require_relative 'test_helper'
require_relative '../library/geometry/lib/vec2d'

Dir.chdir(File.dirname(__FILE__))

# Vec2D test
class Vec2DTest < Minitest::Test

  def setup

  end

  def test_left
    a = Vec2D.new(3.0000000, 5.00000)
    expect = Vec2D.new(-5.0000000, 3.00000)
    assert_equal(expect, a.left, 'Failed left')
  end

  def test_reflect
    a = Vec2D.new(3.0000000, 5.00000)
    normal = Vec2D.new(-1.0, 1.0)
    vector = a.reflect(normal)
    expect = Vec2D.new(7.0, 1.00000)
    assert vector.java_kind_of?(Vec2D)
    assert_equal(expect, vector, 'Failed reflect')
  end

  def test_equals_when_close
    a = Vec2D.new(3.0000000, 5.00000)
    b = Vec2D.new(3.0000000, 5.000001)
    assert_equal(a, b, 'Failed to return equal when v. close')
  end

  def test_sum
    a = Vec2D.new(3, 5)
    b = Vec2D.new(6, 7)
    c = Vec2D.new(9, 12)
    assert_equal(a + b, c, 'Failed to sum vectors')
  end

  def test_subtract
    a = Vec2D.new(3, 5)
    b = Vec2D.new(6, 7)
    c = Vec2D.new(-3, -2)
    assert_equal(a - b, c, 'Failed to subtract vectors')
  end

  def test_multiply
    a = Vec2D.new(3, 5)
    b = 2
    c = a * b
    d = Vec2D.new(6, 10)
    assert_equal(c, d, 'Failed to multiply vector by scalar')
  end

  def test_divide
    a = Vec2D.new(3, 5)
    b = 2
    c = Vec2D.new(1.5, 2.5)
    d = a / b
    assert_equal(c, d, 'Failed to divide vector by scalar')
  end

  def test_dot
    a = Vec2D.new(3, 5)
    b = Vec2D.new(6, 7)
    assert_in_epsilon(a.dot(b), 53, 0.001, 'Failed to dot product')
  end

  def test_self_dot
    a = Vec2D.new(3, 5)
    assert_in_epsilon(a.dot(a), 34, 0.001, 'Failed self dot product')
  end

  def test_assign_value
    a = Vec2D.new(3, 5)
    a.x = 23
    assert_equal(a.x, 23, 'Failed to assign x value')
  end

  def test_mag
    a = Vec2D.new(-3, -4)
    assert_in_epsilon(a.mag, 5, 0.001,'Failed to return magnitude of vector')
  end

  def test_mag_variant
    a = Vec2D.new(3.0, 2)
    b = Math.sqrt(3.0**2 + 2**2)
    assert_in_epsilon(a.mag, b, 0.001, 'Failed to return magnitude of vector')
  end

  def test_mag_zero_one
    a = Vec2D.new(-1, 0)
    assert_in_epsilon(a.mag, 1, 0.001, 'Failed to return magnitude of vector')
  end

  def test_plus_assign
    a = Vec2D.new(3, 5)
    b = Vec2D.new(6, 7)
    a += b
    assert_equal(a, Vec2D.new(9, 12), 'Failed to += assign')
  end

  def test_normalize
    a = Vec2D.new(3, 5)
    b = a.normalize
    assert_in_epsilon(b.mag, 1, 0.001, 'Failed to return a normalized vector')
  end

  def test_normalize!
    a = Vec2D.new(3, 5)
    a.normalize!
    assert_in_epsilon(a.mag, 1, 0.001, 'Failed to return a normalized! vector')
  end

  def test_rotate
    x, y = 20, 10
    b = Vec2D.new(x, y)
    a = b.rotate(Math::PI / 2)
    assert_equal(a, Vec2D.new(-10, 20), 'Failed to rotate vector by scalar radians')
  end

  def test_inspect
    a = Vec2D.new(3, 2.000000000000001)
    assert_equal(a.inspect, 'Vec2D(x = 3.0000, y = 2.0000)')
  end

  def test_array_reduce
    array = [Vec2D.new(1, 2), Vec2D.new(10, 2), Vec2D.new(1, 2)]
    sum = array.reduce(Vec2D.new) { |c, d| c + d }
    assert_equal(sum, Vec2D.new(12, 6))
  end

  def test_array_zip
    one = [Vec2D.new(1, 2), Vec2D.new(10, 2), Vec2D.new(1, 2)]
    two = [Vec2D.new(1, 2), Vec2D.new(10, 2), Vec2D.new(1, 2)]
    zipped = one.zip(two).flatten
    expected = [Vec2D.new(1, 2), Vec2D.new(1, 2), Vec2D.new(10, 2), Vec2D.new(10, 2), Vec2D.new(1, 2), Vec2D.new(1, 2)]
    assert_equal(zipped, expected)
  end

  def test_cross_area # NB: the sign might be negative
    a = Vec2D.new(200, 0)
    b = Vec2D.new(0, 200)
    # Expected result is an area, twice that of the triangle created by the vectors
    assert_equal((a).cross(b).abs, 40_000.0, 'Failed area test using 2D vector cross product')
  end

  def test_cross_non_zero # Could be used to calculate area of triangle
    a = Vec2D.new(40, 40)
    b = Vec2D.new(40, 140)
    c = Vec2D.new(140, 40)
    assert_equal((a - b).cross(b - c).abs / 2, 5_000.0, 'Failed area calculation using 2D vector cross product')
  end

  def test_cross_zero # where a, b, c are collinear area == 0
    a = Vec2D.new(0, 0)
    b = Vec2D.new(100, 100)
    c = Vec2D.new(200, 200)
    # see http://mathworld.wolfram.com/Collinear.html for details
    assert((a - b).cross(b - c).zero?, 'Failed collinearity test using 2D vector cross product')
  end
end
