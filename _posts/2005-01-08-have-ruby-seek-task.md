---
layout: post
title : "have ruby, seek task"
date  : "2005-01-08T03:09:00Z"
tags  : ["programming", "ruby"]
---
I really like Ruby.  Working with it is just so much fun!  I wrote my checkbook
balancer in it, and everything else I do is pretty much just messing around
because it's fun.  I need to find something more practical to do, but it's
usually easier for me to use Perl instead.

Today, I wondered how easy it would be to iterate over an array in n-sized
chunks at a time.  This came to mind because I want to iterate over pairs in a
list in Rubric's code.  (I wish I'd written it in Ruby, sort of.)

So, I ended up writing a few methods for Array.  It wasn't hard, but I rewrote
them a number of times, each time feeling like I was getting a better grip on
the Ruby Way.

```ruby
class Array
  def each_n(n, &block)
    (0 .. (self.size/n.to_f).ceil - 1).map { |i| block.call(self[i*n,n]) }
  end
  def collect_n(n, &block)
    c = []

    *each_n(n) { |nth| block.call(nth).each { |x| c << x } }

    return c
  end
  def collect_n!(n, &block)
    self[0, self.size] = self.collect_n(n, &block)
  end
  alias_method :map_n,  :collect_n
  alias_method :map_n!, :collect_n!
end
```

`each_n` iterates over the Array, invoking the passed block once for each
n-sized chunk, which is passed as an Array.  collect_n maps these chunks
through the block.  As Ruby standards suggest, collect_n! does the mapping and
replaces the original list's contents with the result.

What fun!

I don't have personal application for this, so I had some pretty silly
test/demo code:


```ruby
digits = [ 1,2,3,4,5,6,7,8,9 ]

puts "digits counted in fives:"

*each_n(5) { |x| puts x, "---" }

puts "digits, multipled in threes by [0,1,2], counted in fives:"

*collect_n!(3) { |nth| i = -1; nth.map { |x| x * i+=1; } }
*each_n(5) { |x| puts x, "---" }
```

I should learn to use Ruby's testing framework for this sort of thing!
