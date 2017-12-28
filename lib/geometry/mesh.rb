class Mesh
  attr_accessor :vertices
  attr_accessor :incidences
  attr_accessor :opposites
  attr_accessor :triangles

  def initialize(triangulation, polygon = nil)
    @triangles = []
    @opposites = []
    @vertices = {}
    vertices = {}
    @incidences = []
    waiting = {}
    i = 0
    corner = 0
    triangulation.each do |triangle|
      # If its bad don't do it please
      next unless triangle.all? {|p| p.in_bounds?(800, 600)}
      next if !(polygon.nil? || triangle.segments.all? {|seg| seg.in_polygon?(polygon)})
      @triangles << triangle
      triangle.clockwise.each do |point|
        vertices[point] = (i += 1) if !vertices.key?(point)
        @incidences << vertices[point]
        opposite = triangulation.opposite(point, triangle)
        opp_triangle = triangulation.opposite_triangle(point, triangle)
        # Case where opposite is pointing into outer triangle
        if opposite.in_bounds?(800, 600)
          # Case where triangle is invalid
          if opp_triangle.segments.all? {|seg| seg.in_polygon?(polygon)}
            waiting[corner] = [opposite, opp_triangle]
          else
            @opposites[corner] = corner
          end
        else
          @opposites[corner] = corner
        end
        corner += 1
      end
    end
    # Calculate Corners
    waiting.each do |c, opposing|
      opposite, triangle = opposing
      id = @triangles.index(triangle)
      vertex_id = vertices[opposite]
      sub = @incidences[(3*id)..(3*id+2)]
      @opposites[c] = sub.index(vertex_id) + 3 * id
    end
    # Invert vertices hash to get vertex table
    @vertices = vertices.invert
  end

  def triangle(c)
    return c / 3
  end

  def after(c)
    return 3 * triangle(c) + (c + 1) % 3
  end

  def before(c)
    return 3 * triangle(c) + (c - 1) % 3
  end

  def vertex(c)
    return incidences[c]
  end

  def point(c)
    return vertices[vertex(c)]
  end

  def border?(c)
    return opposites[c] == c
  end

  def opposite(c)
    return opposites[c]
  end

  def left(c)
    return opposite(before(c))
  end

  def right(c)
    return opposite(after(c))
  end

  def swing(c)
    return before(opposite(before(c)))
  end
end
