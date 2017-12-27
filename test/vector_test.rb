require_relative 'test_helper'
require 'propane'
require_relative '../library/geometry/lib/vector'
require_relative '../library/geometry/lib/vec2d'

Dir.chdir(File.dirname(__FILE__))

# Vector test
class VectorTest < Minitest::Test
  Point = Struct.new(:x, :y)
  attr_reader :point

  def setup
    @point = Point.new(30, 50)
  end

  def test_points
    vector = Vector2D.points(point, Vec2D.new(60, 70))
    assert vector.java_kind_of?(Vec2D)
    assert_equal Vec2D.new(30, 20), vector
  end
end
