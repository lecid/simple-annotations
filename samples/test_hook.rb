require 'rubygems'
require 'simple-annotations'

class A
  using AnnotationRefinement

  annotate!

  
  §after -> { puts 'after' }
  §before -> { puts 'before' }
  def m1
    puts 'test'
  end

  
end



anA = A.new
anA.m1