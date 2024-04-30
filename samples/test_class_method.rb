require 'rubygems'
require 'simple-annotations'

class A
  using AnnotationRefinement

  annotate!

  §test 1234
  def m1

  end

  §foo 12
  §bar
  def m2; end

  §foobar color: 'cyan'
  def m3; end

  def m4; end

  §after -> { puts 'm5 after' }
  def m5; end

  §test 10, {}, [], 'string'
  def m6; end
end


pp A.annotations

pp A.annotations[:m3]


