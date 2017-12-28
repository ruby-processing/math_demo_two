# Here we extend built in Vec2D class to add required functionality
# NB: using :mag in place of :length and :* scalar instead of scale
class Vec2D
  def left
    Vec2D.new(-y, x)
  end

  def reflect(normal)
    other = -2 * dot(normal)
    Vec2D.new(x + other * normal.x, y + other * normal.y)
  end
end
