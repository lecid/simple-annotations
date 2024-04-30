# Simple Annotations 4 Ruby

Simple method annotations like in java or Python methods decorators


![GitHub](https://img.shields.io/github/license/Ultragreen/simple-annotations)

[![Documentation](https://img.shields.io/badge/docs-rubydoc.info-brightgreen)](https://rubydoc.info/gems/simple-annotations)
![GitHub issues](https://img.shields.io/github/issues/Ultragreen/simple-annotations)
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/Ultragreen/simple-annotations)
![GitHub top language](https://img.shields.io/github/languages/top/Ultragreen/simple-annotations)
![GitHub milestones](https://img.shields.io/github/milestones/open/Ultragreen/simple-annotations)

![Gem](https://img.shields.io/gem/dt/simple-annotations)
[![Gem Version](https://badge.fury.io/rb/sc4ry.svg)](https://badge.fury.io/rb/simple-annotations)
![Twitter Follow](https://img.shields.io/twitter/follow/Ultragreen?style=social)
![GitHub Org's stars](https://img.shields.io/github/stars/Ultragreen?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/Ultragreen/simple-annotations?style=social)


<noscript><a href="https://liberapay.com/ruydiaz/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a></noscript>

## Installation

Install it yourself as:

    $ gem install carioca




##  Usage

## Adding annotations to a class


```ruby 
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

```

Display 

```
{:test=>"string"}
```


### Getting fields

```ruby 
require 'rubygems'
require 'simple-annotations'

class A
  using AnnotationRefinement
  annotate!

  §foobar {:color => 'cyan' }   # Hash
  §test 1234                    # Numeric
  §foobar color: 'cyan'         # Hash by double splat, like keyword
  §testbar 10, {}, [], 'string' # Hybrid by splat
  §barfoo                       # Boolean set true
  §footest 'string'             # String                    
  def method
      [...]
  end

end

pp A.annotations[:method]

```

Display

```
{:test=>1234, :foobar=>{:color=>"cyan"}, :testbar=>[10, {}, [], "string"], :barfoo=>true, :footest=>"string"}
```

### Defining Hooks

Supporting 2 Hooks :

- §after
- §before

Like :

```ruby 
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
```

Display

```
before
test
after
```