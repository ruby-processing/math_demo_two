# NB: We cannot use Vector name because `matrix` module has Vector class
class Vector2D
  def self.points(start, finish)
    Vec2D.new(finish.x - start.x, finish.y - start.y)
  end
end
