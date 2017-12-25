# draw module
module Draw
  include Processing::Proxy
  def draw_point(point, thick = 2)
    ellipse(point.x, point.y, thick, thick)
  end

  def draw_vector(vector, point = Point.new)
    line(point.x, point.y, point.x + vector.x, point.y + vector.y)
  end

  def draw_arrow(vector, point = Point.new)
    draw_vector(vector, point)
    final = point + vector
    mag = [height / 50, vector.mag / 10].min
    vector = vector.normalize
    a = vector.rotate(-Math::PI / 8) * mag
    b = vector.rotate(Math::PI / 8) * mag
    draw_vector(a, final - a)
    draw_vector(b, final - b)
  end

  def draw_polygon(polygon, hash = {})
    hash.key?(:open) ? begin_shape(hash[open]) : begin_shape
    polygon.each do |point|
      vertex(point.x, point.y)
    end
    hash.key?(:close) ? end_shape(hash[close]) : end_shape(CLOSE)
  end

  def draw_smooth_polygon(polygon, refine = 5, hash = {})
    p = polygon.dup
    vertices = p.vertices.dup
    refine.times do
      copy = vertices.dup
      size = copy.size
      copy.each_index do |i|
        prev, cur, nex, nnex = copy.values_at((i - 1) % size, i, (i + 1) % size, (i + 2) % size)
        vertices[2 * i] = cur
        vertices[2 * i + 1] = Point.towards(
          Point.towards(prev, 9.0 / 8, cur),
          0.5,
          Point.towards(nnex, 9.0 / 8, nex)
        )
      end
    end
    p.vertices = vertices
    draw_polygon(p, hash)
  end
end

# pt L(pt A, float s, pt B) {return P(A.x+s*(B.x-A.x),A.y+s*(B.y-A.y)); }; // Linear interpolation: A+sAB
# pt B(pt A, pt B, pt C, float s) {return( L(L(B,s/4.,A),0.5,L(B,s/4.,C))); }; // returns a tucked B towards its neighbors
# pt F(pt A, pt B, pt C, pt D, float s) {return( L(L(A,1.+(1.-s)/8.,B) ,0.5, L(D,1.+(1.-s)/8.,C))); }; // returns a bulged mid-edge point
