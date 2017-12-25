# Segment class
class Segment < Line
  def contains?(point)
    point.between?(start, finish)
  end

  # xor operations on booleans true ^ false = true,
  # true ^ true = false, and false ^ false = false
  def cross?(segment)
    right_of?(segment.start) ^ right_of?(segment.finish) &&
      segment.right_of?(start) ^ segment.right_of?(finish)
  end

  def right_of?(point)
    !point.right_of?(start, finish)
  end

  def ==(other)
    [start, finish].include?(other.start) &&
      [start, finish].include?(other.finish)
  end

  def in_polygon?(polygon)
    vertices = polygon.vertices
    return false unless vertices.include?(start) || start.in_polygon?(polygon)
    return false unless vertices.include?(finish) || finish.in_polygon?(polygon)
    mid = Point.towards(start, 0.5, finish)
    mid.on_polygon?(polygon) || mid.in_polygon?(polygon)
  end

  def inspect
    start.inspect + '->' + finish.inspect
  end
end
