require_relative 'triangle'

class Triangulation
  attr_accessor :recent
  attr_accessor :graph

  def initialize(triangle)
    @graph = Graph.new
    @graph.add(triangle)
    @recent = triangle
  end

  def triangles
    @graph.triangles
  end

  def contains?(triangle)
    @graph.contains?(triangle)
  end

  def opposite(point, triangle)
    opptri = @graph[triangle].detect { |neighbor| !neighbor.vertex?(point) }
    (opptri.to_a - (triangle.to_a - [point]))[0]
  end

  def opposite_triangle(point, triangle)
    @graph[triangle].detect { |neighbor| !neighbor.vertex?(point) }
  end

  def surrounding(point, triangle)
    queue = [triangle]
    visited = {}
    list = []
    until queue.empty?
      tri = queue.pop
      next if visited.key?(tri)
      list << tri
      visited[tri] = true
      @graph[tri].each do |neigh|
        queue << neigh if neigh.vertex?(point) && !visited.key?(neigh)
      end
    end
    list
  end

  def locate(point)
    triangle = contains?(@recent) ? @recent : nil
    visited = {}
    until triangle.nil?
      break if visited.key?(triangle)
      visited[triangle] = true
      return triangle if point.in_triangle?(*triangle)
      max = 0
      corner = nil
      triangle.each do |p|
        if point.distance(p) > max
          corner = p
          max = point.distance(p)
        end
      end
      triangle = opposite_triangle(corner, triangle)
    end

    triangles.each do |tri|
      return tri if point.in_triangle?(*tri)
    end
    nil
  end

  def add(point)
    tri = locate(point)
    return if tri.nil? # the point is on one of the triangles or out of bounds
    cav = cavity(point, tri)
    @recent = update(point, cav)
  end

  def cavity(point, triangle)
    encroached = {}
    checking = [triangle]
    marked = { triangle => true }
    until checking.empty?
      triangle = checking.shift
      next if triangle.delaunay?(point)

      encroached[triangle] = true
      @graph[triangle].each do |neighbor|
        next if marked.key?(neighbor)
        marked[neighbor] = true
        checking << neighbor
      end
    end
    encroached.keys
  end

  def update(point, cavity)
    boundary = {}
    the_triangles = []
    cavity.each do |triangle|
      the_triangles.concat(@graph[triangle])
      triangle.each do |vertex|
        facet = triangle.opposite(vertex)
        boundary.key?(facet) ? boundary.delete(facet) : boundary[facet] = true
      end
    end
    the_triangles -= cavity
    cavity.each { |triangle| @graph.remove(triangle) }
    new_triangles = {}
    boundary.each_key do |pts|
      # a, b, c = point, pts
      tri = Triangle.new(point, *pts)
      @graph.add(tri)
      new_triangles[tri] = true
    end
    the_triangles.concat(new_triangles.keys)
    new_triangles.each_key do |triangle|
      the_triangles.each do |other|
        @graph.add(triangle, other) if triangle.neighbor?(other)
      end
    end
    new_triangles.keys[0]
  end

  def each
    @graph.triangles.each { |t| yield t }
  end
end

# graph helper class
class Graph
  attr_accessor :data

  def initialize
    @data = Hash.new([])
  end

  def [](triangle)
    @data[triangle]
  end

  def add(triangle, neighbor = nil)
    if neighbor.nil?
      return if @data.key?(triangle)
      @data[triangle] = []
    else
      @data[triangle] << neighbor unless @data[triangle].include?(neighbor)
      @data[neighbor] << triangle unless @data[neighbor].include?(triangle)
    end
  end

  def remove(triangle, neighbor = nil)
    if neighbor
      @data[triangle].delete(neighbor)
      @data[neighbor].delete(triangle)
    else
      neighbors = @data[triangle]
      neighbors.each do |neigh|
        @data[neigh].delete(triangle)
      end
      @data.delete(triangle)
    end
  end

  def triangles
    @data.keys
  end

  def contains?(triangle)
    @data.key?(triangle)
  end
end
