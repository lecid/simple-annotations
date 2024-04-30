require 'rubygems'
require 'simple-annotations'

class A
  using AnnotationRefinement

  annotate!

  §test 'string'
  def method
    return annotations(__callee__)
  end

  
end



anA = A.new
pp anA.method
