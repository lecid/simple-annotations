require 'rubygems'
require 'simple-annotations'

class A
  using AnnotationRefinement

  annotate!

  §test 1234                    # Numeric
  §foobar color: 'cyan'         # Hash by double splat, like keyword
  §testbar 10, {}, [], 'string' # Hybrid by splat
  §barfoo                       # Boolean set true
  §footest 'string'             # String                    
  def method
      
  end

end


pp A.annotations[:method]