# frozen_string_literal: true
require 'matrix'
require_relative 'point'
# Circumcircle from 3 points, public :inside? method
class Circumcircle
  attr_reader :center, :radius, :points
  def initialize(a, b, c)
    @points = [a, b, c]
  end

  def inside?(vec)
    center.distance_squared(vec) < radius_squared
  end

  def center
    Point.new(-(bx / am), -(by / am))
  end

  private

  def radius_squared
    center.distance_squared(points[2])
  end

  # Matrix math see matrix_math.md and in detail
  # http://mathworld.wolfram.com/Circumcircle.html

  def am
    2 * Matrix[
      *points.map { |pt| [pt.x, pt.y, 1] }
    ].determinant
  end

  def bx
    -Matrix[
      *points.map { |pt| [pt.x * pt.x + pt.y * pt.y, pt.y, 1] }
    ].determinant
  end

  def by
    Matrix[
      *points.map { |pt| [pt.x * pt.x + pt.y * pt.y, pt.x, 1] }
    ].determinant
  end
end
