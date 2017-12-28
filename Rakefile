
task default: [:gem, :test]

desc 'Build gem'
task :gem do
  sh 'gem build math_demo_two.gemspec'
end

desc 'Test'
task :test do
  sh 'jruby test/circumcircle_test.rb'
  sh 'jruby test/vec2d_test.rb'
  sh 'jruby test/point_test.rb'
  sh 'jruby test/line_test.rb'
  sh 'jruby test/vector_test.rb'
end
