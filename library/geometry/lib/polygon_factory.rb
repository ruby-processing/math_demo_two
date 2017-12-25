require_relative 'polygon'
# factory module avoids some bloat in Polygon
module PolygonFactory
  def self.n_gon(vertices, center, radius)
    points = (0..vertices).map do |i|
      angle = Math::PI * (1 - i * 4.0 / vertices) / 2
      x = center.x + radius * Math.cos(angle)
      y = center.y + radius * Math.sin(angle)
      Point.new(x, y)
    end
    Polygon.new(*points)
  end

  def self.convex_hull(polygon)
    vert = polygon.vertices
    vertices = []
    p = vert.min
    vert.sort!
    start = p
    vertices << start
    loop do
      n = -1
      dist = 0
      vert.each_with_index do |point, i|
        next if point == p
        n = i if n == -1
        cross = p.to(point).cross(p.to(vert[n]))
        d = p.distance(point)
        if cross < 0
          n = i
          dist = d
        elsif cross.zero? && d > dist
          dist = d
          n = i
        end
      end
      p = vert[n]
      break if start == p
      vertices << p
    end
    vertices.pop
    vertices.delete_at(1) if vertices[1].between?(vertices[0], vertices[2])
    vertices.delete_at(-1) if vertices[-1].between?(vertices[0], vertices[-2])
    Polygon.new(*vertices)
  end

  def self.mirror(polygon, width = 800)
    vertices = polygon.vertices
    new_vertices = vertices.map { |point| Point.new(width - point.x, point.y) }
    Polygon.new(*new_vertices)
  end
end
