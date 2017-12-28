# The triangle class
class Triangle
  include Enumerable

  attr_accessor :a, :b, :c

  def initialize(a, b, c)
    @a = a
    @b = b
    @c = c
  end

  def get_vertex(*args)
    (clockwise - args).first
  end

  def vertex?(point)
    a == point || b == point || c == point
  end

  def neighbor?(triangle)
    count = 0
    [a, b, c].each do |vertex|
      count += 1 if triangle.vertex?(vertex)
    end
    count == 2
  end

  def opposite(point)
    [a, b, c] - [point]
  end

  def each
    [a, b, c].each { |p| yield p }
  end

  def clockwise?
    normal < 0
  end

  def delaunay?(point)
    !in_circumcircle?(point)
  end

  def in_circumcircle?(point)
    point.in_circumcircle?(a, b, c)
  end

  def circumcircle
    Circumcircle.new(a, b, c).center
  end

  def sanitize!
    @a, @b, @c = [a, c, b] unless clockwise?
  end

  def clockwise
    clockwise? ? to_a : [a, c, b]
  end

  def normal
    ab = a.to(b)
    ac = a.to(c)
    ab.cross(ac)
  end

  def to_a
    [a, b, c]
  end

  def segments
    [Segment.new(a, b), Segment.new(b, c), Segment.new(c, a)]
  end

  def eql?(other)
    (to_a | other.to_a).size == 3
  end
end
