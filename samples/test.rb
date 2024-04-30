require 'rubygems'
require 'simple-annotations'

class A
  using AnnotationRefinement

  annotate!

  §toto 'string'
  §after -> { puts 'after' }
  §before -> { puts 'before' }
  def m1
    puts 'see all annotations'
    pp annotations
    puts 'annotation for this method'
    pp annotations(__callee__)
    puts 'display hooks'
    pp hooks
    puts 'display fields'
    pp fields
  end

  §toto 12
  §titi
  def m2; end

  §foobar color: 'cyan'
  def m3; end

  def m4; end

  §after -> { puts 'm5 after' }
  def m5; end

  §test 10, {}, [], 'string'
  def m6; end
end

puts 'Class annotations'
pp A.annotations

anA = A.new
anA.m1
