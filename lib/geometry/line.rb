# line class
class Line
  attr_reader :start, :finish

  def self.points(x1, y1, x2, y2)
    Line.new(Point.new(x1, y1), Point.new(x2, y2))
  end

  def initialize(start, finish)
    @start = start
    @finish = finish
  end

  def contains?(point)
    to_start = point.to(start)
    to_start.cross(vector).zero?
  end

  def cross?(line)
    !vector.cross(line.vector).zero?
  end

  def intersect(line)
    a1 = finish.y - start.y
    a2 = line.finish.y - line.start.y
    b1 = finish.x - start.x
    b2 = line.finish.x - line.start.x
    c1 = a1 * finish.x + b1 * start.y
    c2 = a2 * finish.x + b2 * finish.y
    det = (a1 * b2 - a2 * b1).to_f
    x = (b2 * c1 - b1 * c2) / det
    y = (a1 * c2 - a2 * c1) / det
    Point.new(x, y)
  end

  def vector
    start.to(finish)
  end
end
