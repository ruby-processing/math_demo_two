# math_demo_two
Updated [random-graphics](https://github.com/TricksterGuy/random-graphics) by TricksterGuy (aka Brandon Whitehead) from an early version of ruby-processing to propane (a standalone version of ruby-processing for propane-3.3.6 and using jruby-9.1.15.0).  The original was done as a CS exercise using an early version of ruby-processing-0.8, at which time the processing guys had not implemented PVector and there wasn't the Vec2D available with later version of ruby-processing (and hence JRubyArt and propane) so Brandon implemented his own Vector class. Here we make use propane Vec2D class and extend it to add functionality required by Brandons code. Since recent versions of processing the export to Applet is no longer available, however running this app is a simple as installing jruby and the following:-

```bash
jgem install propane
jruby random-graphics
```
