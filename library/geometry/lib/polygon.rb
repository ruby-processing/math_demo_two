class Polygon
  include Enumerable
  attr_accessor :vertices

  def initialize(*args)
    @vertices = args
  end

  def [](index)
    return @vertices[index]
  end

  def add(point)
    @vertices << point
  end

  def <<(point)
    @vertices << point
    return self
  end

  def translate!(x, y)
    @vertices.each {|point| point.translate!(x, y)}
  end

  def translate(x, y)
    p = Polygon.new(*@vertices)
    p.vertices.collect! {|point| point.translate(x, y)}
    return p
  end

  def each
    @vertices.each {|point| yield point}
  end

  def each_edge
    @vertices.each_index do |i|
      yield @vertices[i], @vertices[(i + 1) % @vertices.size]
    end
  end

  def each_segment
    each_edge {|a, b| yield Segment.new(a, b)}
  end

  def segments
    ary = []
    each_segment {|s| ary << s}
    return ary
  end

  def size
    return @vertices.size
  end

  def closest_point(point, max = Float::INFINITY)
    min = Float::INFINITY
    chosen = @vertices[0]
    @vertices.each do |vertex|
      if vertex.distance(point) < min
        chosen = vertex
        min = vertex.distance(point)
      end
    end
    min > max ? nil : chosen
  end

  def area
    a = 0
    each_edge do |p1, p2|
      a += p1.translation.cross(p2.translation)
    end
    a.abs / 2
  end

  def perimeter
    a = 0
    each_edge do |p1, p2|
      a += p1.distance(p2)
    end
    a
  end

  # def convex_hull
  #   vertices = []
  #   p = @vertices.min
  #   @vertices.sort!
  #   start = p
  #   vertices << start
  #   loop do
  #     n = -1
  #     dist = 0
  #     @vertices.each_with_index do |point, i|
  #       n = i if n == -1
  #       cross = (p.to(point)).cross(p.to(@vertices[n]))
  #       d = p.distance(point)
  #       if cross < 0
  #         n = i
  #         dist = d
  #       elsif cross == 0 and d > dist
  #         dist = d
  #         n = i
  #       end
  #     end
  #     p = @vertices[n]
  #     break if point == p
  #     vertices << p
  #   end
  #   vertices.pop
  #   vertices.delete_at(1) if vertices[1].between?(vertices[0], vertices[2])
  #   vertices.delete_at(-1) if vertices[-1].between?(vertices[0], vertices[-2])
  #   return vertices
  # end

  def mirror(width = 800)
    polygon = Polygon.new
    each do |p|
      polygon.add(Point.new(width - p.x, p.y))
    end
    return polygon
  end

  def closest(point)
    min = Float::INFINITY
    close = @vertices[0]
    @vertices.each do |p|
      if min > point.distance(p)
        close = p
        min = point.distance(p)
      end
    end
    return close
  end
end
