# math_demo_two
Updated [random-graphics](https://github.com/TricksterGuy/random-graphics) by TricksterGuy (aka Brandon Whitehead) from an early version of ruby-processing to propane (a standalone version of ruby-processing for propane-3.3.6 and using jruby-9.1.15.0).  The original was done as a CS exercise (CS3451 project 5 Georgia Tech), using an early version of ruby-processing-0.8 (released 19 Apr 2008), at which time the processing guys had not implemented PVector and there wasn't the Vec2D class which was available with later version of ruby-processing (and hence JRubyArt and propane) so Brandon implemented his own Vector class. Here we make use propane Vec2D class and extend it to add functionality required by Brandons code. Since recent versions of processing the export to Applet is no longer available, however running this app is a simple as installing jruby and the following:-

```bash
jgem install propane
jruby random-graphics
```

I don't know whether it was Brandons or Jarek Rossignacs idea to do the implementation in ruby-processing, but it is an interesting choice. Today many people rely on some version of John Lloyds Quickhull3D in java in processing sketches to create meshes. Such as [Lee Byron mesh processing](http://leebyron.com/mesh/) or [toxiclibs](http://toxiclibs.org/) by Karsten Schmidt. You can access toxiclibs in propane and JRubyArt by installing the [gem](http://ruby-processing.github.io/toxicgem/).

Another feature not available with early versions of ruby-processing is the `load_library` function that facilitates the use of ruby or java libraries in your sketches. Here we create the `geometry` library, so that we can separate the sketch file from the supporting files.
