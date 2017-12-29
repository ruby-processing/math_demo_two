#!/usr/bin/env jruby

# After an original for ruby-processing by Brandon Whitehead
require 'propane'
require_relative 'geometry/geometry'

class GraphicsTest < Propane::App

  include Draw

  attr_reader :polygon

  def settings
    size 800, 600
  end

  def setup
    sketch_title 'Test'
    @show_help = true
    @smooth = false
    @mode = 'c'
    @color = false
    @mat = false
    frame_rate(64)
    font = create_font('Courier', 14)
    text_font(font, 14)
    @polygon = PolygonFactory.n_gon(16, Point.new(400, 300), 250)
    @points = []
  end

  def draw
    background(color(204, 204, 204))
    @show_help ? show_help : actions
  end

  def key_pressed
    case key
    when ' '
      @show_help = !@show_help
    when '>'
      double_vertices
    when '<'
      halfen_vertices
    when '.'
      double_inner_point
    when ','
      halfen_inner_point
    when 'c'
      @points.clear
    when 'C'
      @polygon = PolygonFactory.convex_hull(polygon)
    when 'g'
      @smooth = !@smooth
    when 'e'
      @mode = 'c'
    when 't'
      # Rebuild Triangulation if was in curve
      init_triangulation if @mode == 'c'
      @mode = 't'
    when 'm'
      # Build Triangulation first
      init_triangulation if @mode == 'c'
      @mode = 'm'
      @mesh = Mesh.new(@triangulation, polygon)
      @corner = 0
    when 'M'
      @mat = !@mat
    when 'x'
      @mode = 'm'
      mirror_mesh
      @corner = 0
    when 'v'
      # Build Triangulation first
      init_triangulation if @mode == 'c'
      @mode = 'v'
    when 'R'
      resample
    when 'I'
      @color = !@color
    when 'l'
      @corner = @mesh.left(@corner)
    when 'r'
      @corner = @mesh.right(@corner)
    when 's'
      @corner = @mesh.swing(@corner)
    when 'n'
      @corner = @mesh.after(@corner)
    when 'p'
      @corner = @mesh.before(@corner)
    when 'o'
      @corner = @mesh.opposite(@corner)
    when 'q', 'Q'
      Processing.app.exit
    end
  end

  def mouse_pressed
    mouse_point = Point.new(mouse_x, mouse_y)
    @point = polygon.closest_point(mouse_point, 4)
    if key_pressed? and key == 'd' and @point.nil?
      closest = polygon.closest(mouse_point)
      index = polygon.vertices.index(closest)
      polygon.vertices.insert(index + 1, mouse_point)
    elsif @point.nil? and mouse_point.in_polygon?(polygon)
      @points << mouse_point
    end
  end

  def mouse_released
    @point = nil
  end

  def actions
    case @mode
    when 't'
      draw_triangulation
    when 'm'
      draw_mesh
      stroke(color(255, 255, 255))
      draw_point(@mesh.point(@corner), 10)
      stroke(color(0, 0, 0))
    when 'v'
      draw_voronoi
    else
      if mouse_pressed? && !key_pressed? and !@point.nil?
        @point.translate!(mouse_x - pmouse_x, mouse_y - pmouse_y)
      end
      @smooth ? draw_smooth_polygon(polygon) : draw_polygon(polygon)
    end
    polygon.each {|point| draw_point(point, 4)}
    @points.each {|point| draw_point(point, 2)}
    draw_mat if (@mat && !@triangulation.nil?)
  end

  def show_help
    @line = 1
    fill(color(0, 0, 128))
    scribe('Press q or Q to quit')
    scribe('')
    scribe('To insert a point hold d and click in/on the polygon')
    scribe('To modify vertex count press < or >')
    scribe('To show the Delaunay triangulation press t')
    scribe('To show the MAT sample points press M')
    scribe('To add/remove random points in the polygon press , or .')
    scribe('To Laplace smooth the points press S (not functional)')
    scribe('To bulge into 3D press b (not functional)')
    scribe('To animate the 3d mesh press a (not functional)')
    scribe('To compute the isolation measure press I')
    scribe('')
    scribe('To turn on smoothing press g')
    scribe('To compute the convex hull of the polygon press C')
    scribe('To resample the polygon press R')
    scribe('To clear all points in the interior of the polygon press c')
    scribe('')
    scribe('Modes')
    scribe('Press e for curve editing mode')
    scribe('Press t for triangulation viewing mode')
    scribe('Press v for viewing voronoi diagram')
    scribe('Press m for mesh viewing mode')
    scribe('Press x for mirror mesh (2d) viewing')
    scribe('Press o/s/n/p/l/r while in mesh mode to navigate mesh (look for white circle)')
    scribe('')
    scribe('Press Space to hide this help text')
    no_fill
  end

  def scribe(text)
    text(text, 20, 20 * @line)
    @line += 1
  end

  def init_triangulation
    max = 10_000
    triangle = Triangle.new(Point.new(-max, -max), Point.new(max, -max), Point.new(0, max))
    @triangulation = Triangulation.new(triangle)
    @points.each {|p| @triangulation.add(p)}
    polygon.each {|p| @triangulation.add(p)}
  end

  def mirror_mesh
    @polygon = PolygonFactory.mirror(polygon)
    max = 10_000
    triangle = Triangle.new(Point.new(-max, -max), Point.new(max, -max), Point.new(0, max))
    @triangulation = Triangulation.new(triangle)
    @points.each {|p| @triangulation.add(Point.new(800 - p.x, p.y))}
    polygon.each {|p| @triangulation.add(p)}
    @mesh = Mesh.new(@triangulation, polygon)
  end

  def double_vertices
    vertices = []
    polygon.each_edge do |a, b|
      vertices << a
      vertices << Point.towards(a, 0.5, b)
    end
    @polygon = Polygon.new(*vertices)
  end

  def halfen_vertices
    if polygon.size / 2 >= 3
      vertices = []
      polygon.each_with_index do |a, i|
        vertices << a if i & 1 == 0
      end
      @polygon = Polygon.new(*vertices)
    end
  end

  def double_inner_point
    number = @points.empty? ? 1 : @points.size
    number.times do
      point = Point.new(rand(800), rand(600))
      point = Point.new(rand(800), rand(600)) while !point.in_polygon?(polygon)
      @points << point
    end
  end

  def halfen_inner_point
    number = @points.empty? ? 0 : @points.size / 2
    number.times do
      @points.delete_at(rand(@points.size))
    end
  end

  def resample
    length = polygon.perimeter
    dist = length / polygon.size
    remain = dist
    remain_length = 0
    vertices = 1
    point = Point.from(polygon[0])
    k = 0
    nk = 0
    while vertices < polygon.size
      nk = (k + 1) % polygon.size
      remain_length = point.distance(polygon[nk])
      if remain < remain_length
        point.move_towards!(remain, polygon[nk])
        polygon[vertices].set(point)
        vertices += 1
        remain_length -= remain
        remain = dist
      else
        remain -= remain_length
        point = Point.from(polygon[nk])
        k += 1
      end
    end
  end

  def draw_triangulation
    return if @triangulation.nil?
    triangles = @triangulation.triangles
    triangles = triangles.select {|triangle| triangle.all? {|p| p.in_bounds?(width, height)}}
    triangles.each do |triangle|
      begin_shape
      triangle.each do |point|
        vertex(point.x, point.y)
      end
      end_shape(CLOSE)
    end
  end

  def draw_voronoi
    done = {}
    @triangulation.triangles.each do |triangle|
      # If its bad don't do it please
      next unless triangle.all? { |p| p.in_bounds?(800, 600) }
      triangle.clockwise.each do |point|
        next if done.key?(point)
        done[point] = true
        surround = @triangulation.surrounding(point, triangle)
        polygon = Polygon.new
        i = 0
        surround.each do |tri|
          polygon.add(tri.circumcircle)
          i += 1
        end
        draw_polygon(polygon)
      end
    end
  end

  def draw_mat
    @triangulation.triangles.each do |triangle|
      # If its bad don't do it please
      next unless triangle.all? {|p| p.in_bounds?(800, 600)}
      draw_point(triangle.circumcircle, 2)
    end
  end

  def draw_mesh
    if @color
      fill(color(0, 25, 255))
      normals = @mesh.triangles.dup
      normals.collect! {|t| t.normal.abs}
      maxn = normals.max * 1.2
    end
    @mesh.triangles.each do |triangle|
      java_signature 'int color(float, float, float)'
      fill(color(0, 25, 255 - 255 * triangle.normal.abs / maxn)) if @color
      begin_shape(POLYGON)
      triangle.each do |point|
        vertex(point.x, point.y)
      end
      end_shape(CLOSE)
    end
    no_fill
  end
end
# GraphicsTest.new # would load twice from gem
