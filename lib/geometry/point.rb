# Point class uses Vec2D for math when rquired
require_relative 'vector'
class Point
  include Comparable

  attr_accessor :x
  attr_accessor :y

  def self.from(point)
    new(point.x, point.y)
  end

  def self.translated(point, vector)
    new(point.x + vector.x, point.y + vector.y)
  end

  def self.direction(point, distance, vector)
    new(point.x + distance * vector.x, point.y * distance * vector.y)
  end

  def self.towards(start, distance, finish)
    new(start.x + distance * (finish.x - start.x), start.y + distance * (finish.y - start.y))
  end

  def initialize(x = 0, y = 0)
    @x = x
    @y = y
  end

  def <=>(other)
    return x <=> other.x if (x <=> other.x) != 0
    y <=> other.y
  end

  def ==(other)
    x == other.x && y == other.y
  end

  def +(other)
    translate(other.x, other.y)
  end

  def -(other)
    self + -other
  end

  def set(*args)
    if args.size == 1
      @x, @y = args[0].x, args[0].y
    else
      @x, @y = args
    end
  end

  def translate!(dx, dy)
    @x += dx
    @y += dy
  end

  def translate(dx, dy)
    Point.new(x + dx, y + dy)
  end

  def towards!(s, v)
    @x += s * v.x
    @y += s * v.y
  end

  def towards(s, v)
    Point.new(x + s * v.x, y + s * v.y)
  end

  def translate_towards!(s, p)
    towards!(s, to(p))
  end

  def translate_towards(s, p)
    towards(s, to(p))
  end

  def move_towards!(d, p)
    vec = to(p)
    vec.normalize!
    towards!(d, vec)
  end

  def move_towards(d, p)
    vec = to(p)
    vec.normalize!
    towards(d, vec)
  end

  def rotate!(a, point = Point.new)
    dx = x - point.x
    dy = y - point.y
    c = Math.cos(a)
    s = Math.sin(a)
    @x = point.x + c * dx - s * dy
    @y = point.y + s * dx + c * dy
  end

  def rotate(a, point = Point.new)
    dx = x - point.x
    dy = y - point.y
    c = Math.cos(a)
    s = Math.sin(a)
    x = point.x + c * dx - s * dy
    y = point.y + s * dx + c * dy
    Point.new(x, y)
  end

  def scale!(s)
    @x *= s
    @y *= s
  end

  def scale(s)
    Point.new(@x * s, @y * s)
  end

  def projection!(p, q)
    vec = p.to(self)
    line = p.to(q)
    a = vec.dot(line)
    b = line.distance
    p.towards!(a / b, q)
  end

  def projection(p, q)
    vec = p.to(self)
    line = p.to(q)
    a = vec.dot(line)
    b = line.distance
    p.towards(a / b, q)
  end

  def distance(p)
    Math.sqrt((x - p.x)**2 + (y - p.y)**2)
  end

  def distance_squared(p)
    (x - p.x)**2 + (y - p.y)**2
  end

  def projects?(p, q)
    vec = p.to(self)
    line = p.to(q)
    a = vec.dot(line)
    b = line.distance
    (a > 0) && (a < b)
  end

  def to(other)
    other - Vec2D.new(self)
  end

  def right_of?(a, b)
    ab = a.to(b)
    bc = b.to(self)
    ab = ab.left
    ab.dot(bc) > 0
  end

  def in_triangle?(a, b, c)
    bc = right_of?(b, c)
    ca = right_of?(c, a)
    ab = right_of?(a, b)
    bc && ca && ab || !bc && !ca && !ab
  end

  def between?(a, b)
    ca = to(a)
    cb = to(b)
    between = ca.dot(cb) <= 0
    ca = ca.left
    parallel = ca.dot(cb).abs <= EPSILON
    between && parallel
  end

  def in_bounds?(width, height)
    x_bound = Boundary.new(0, width)
    y_bound = Boundary.new(0, height)
    x_bound.include?(x) && y_bound.include?(y)
  end

  def on_polygon?(polygon)
    polygon.each_segment do |segment|
      return true if segment.contains?(self)
    end
    false
  end

  def in_polygon?(polygon, width = 800, height = 600)
    count = 0
    x2 = rand(width) + width
    y2 = rand(height) + height
    ray = Segment.new(self, Point.new(x2, y2))
    polygon.each_segment do |segment|
      return false if segment.contains?(self)
      count += 1 if ray.cross?(segment)
    end
    count.odd?
  end

  def in_circumcircle?(a, b, c)
    Circumcircle.new(a, b, c).inside?(self)
  end

  def to_s
    "(#{x}, #{y})"
  end

  def inspect
    to_s
  end
end

Boundary = Struct.new(:lower, :upper) do
  def include?(val)
    (lower..upper).cover? val
  end
end
