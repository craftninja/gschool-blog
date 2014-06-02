---
title: Collect, Detect, Inject, Reject, Select and so many more enumerable methods!
date: 2014-06-02 03:00 UTC
tags: ruby, programming, methods
---

Ruby is a super fun programming language to learn. For learning the basics, again I would recommend checking out [Chris Pines' Learn to Program](http://www.amazon.com/Program-Second-Edition-Facets-Series/dp/1934356360/) ([also available in a less up to date version for freeeee](https://pine.fm/LearnToProgram/)).

There are many awesome Ruby concepts that are a little more advanced, for example the Enumerable methods. The Enumerable module is a group of instance methods that can be performed on "collection classes" or items belonging to the class Enumerator, aka any object that falls within the following criteria:

  * The object can use the <code>.each</code> method
  * The object can be compared and then ordered in some way (aka use the <code><=></code>)

What the hex is that <code><=></code> thingie? Well, that is something that compares a collection to another collection. It returns either -1, 0, 1 or nil depending on the result of the comparison. Lets play with that in IRB for a second to give us a glimpse into the logic...

    $ IRB
    > a = [1,2,3,4,5]
    => [1,2,3,4,5]
    > a <=> [1,2,3,4,5]
    => 0
    > a <=> [2]
    => -1
    > a <=> [0,9,9,9,9,9,9,9]
    => 1
    > a <=> ['poop']
    => nil
    
Ok, so I can start to see some of that logic. Ruby goes through the first two elements and compares them, then the second two elements and so forth until something not equal is found. If you can compare these array items string to string or integer to integer or whatnot, either 0, 1 or -1 is returned depending on if the first array is greater (returns a 1) or the second array is greater (returns a -1). If they are not comparable, nil is returned.
 
Hashes are another set of classes that can use the enumerable methods, but for now let's concentrate on using these Enumerable methods on arrays. Hashes can increase the complexity of this subject, but please play with enumerable methods on hashes in IRB. 
For a list of all the enumerable methods available, check out the [http://www.ruby-doc.org/](Ruby Docs) site and search for Enumerable. We are going to cover the following:

    #all?
    #any?
    #collect
    #count
    #detect
    #drop
    #drop_while
    #each_with_index
    #find
    #find_all
    #find_index
    #first
    #grep
    #include?
    #inject
    #map
    #max
    #max_by
    #member?
    #min
    #min_by
    #minmax
    #minmax_by
    #none?
    #one?
    #partition
    #reduce
    #reject
    #reverse_each
    #select
    #sort
    #sort_by
    #take
    #to_a
    #to_h
    #zip

You might have noticed that there is a <code>#</code> in front of all those method names... that is a conventional clue meaning it is an Instance method and NOT a Class method, which would look like this: <code>::new</code>.
    
**\#all?** - returns true or false. Do all elements in the collection match the following pattern? If no block (of code) is supplied, will make sure no elements are false or nil.

    > a = [1,2,3,4,5]
     => [1, 2, 3, 4, 5] 
    > a.all? {|num| num.class == Fixnum}
     => true 
    > a.all? {|num| num.class == String}
     => false 

**\#any?** - returns true or false. Does the collection have any matching the following pattern? If no block is supplied, will make sure at least one item is not false or nil.

    > a = [1,2,3,4,5]
     => [1, 2, 3, 4, 5] 
    > a.any? {|num| num == 3}
     => true 
    > a.any? {|num| num == 'Oh Hai!'}
     => false 

**\#collect** - returns a new collection, does not change original collection. For each element in the collection, run the following block and whatever that block returns, replace it in that position in the new array. If you do not supply a block, an Enumerator Object is returned. **Alias: map**

    > a = [1,2,3,4,5]
     => [1, 2, 3, 4, 5] 
    > a.collect{|num| num * 2}
     => [2, 4, 6, 8, 10] 
    > a
     => [1, 2, 3, 4, 5] 
    > a.collect
     => #<Enumerator: [1, 2, 3, 4, 5]:collect> 
     
**\#count** - returns an integer. Counts the items in the array with no arguments or blocks, counts the instances of an argument if a parameter is passed in, or counts the number of times a boolean is satisfied if a block is passed in.

    > a = [1,2,3,3,4]
     => [1, 2, 3, 3, 4] 
    > a.count
     => 5 
    > a.count(3)
     => 2 
    > a.count {|num| num % 2 == 0}
     => 2 

**\#detect** - returns one item from the collection. Will return the first item that results from the passed block being true. Can add a proc to get a message other than <code>nil</code> for false. Use <code>select</code> instead if you want to return *all* the items that result from true.

    > a = [1,2,3,"four", "five"]
     => [1, 2, 3, "four", "five"] 
    > a.detect {|num| num.class == String}
     => "four"
    > sorry = lambda {"not found, yo"}
     => #<Proc:0x007fbdf9951078@(irb):187 (lambda)>
    > a.detect(sorry) {|a| a==569}
     => "not found, yo"
    > a.detect {|a|a==100}
     => nil 


**\#drop** - returns a new collection, does not change original collection. Drops the specified number of items from the start of collection and returns what is left in the collection.

    > a = [1,2,3,4,5]
     => [1, 2, 3, 4, 5] 
    > a.drop(3)
     => [4, 5] 
    > a
     => [1, 2, 3, 4, 5]


**\#drop_while** - returns a new collection, does not change original collection. Drops all the items until the block is false or nil, then stops looking, returning the rest of the collection.

    > a = [1,2,3,4,0]
     => [0, 1, 2, 3, 4, 0] 
    > a.drop_while {|num| num < 4}
     => [4, 0] 
    > a
     => [0, 1, 2, 3, 4, 0]

**\#each\_with\_index** - returns the collection. Really similar to an each... do. Executes block... if the block mutates the collection, the returned array is also mutated.

    > a = [0,1,2,3,4,5]
     => [0, 1, 2, 3, 4, 5] 
    > a.each_with_index do |num, i|
    >     puts "a[#{i}] = #{num}"
    ?>   end
    a[0] = 0
    a[1] = 1
    a[2] = 2
    a[3] = 3
    a[4] = 4
    a[5] = 5
     => [0, 1, 2, 3, 4, 5] 
     
     > a
      => [0, 1, 2, 3, 4, 5] 
     > a.each_with_index do |num, i|
     >     a[i] = num*2
     ?>   end
      => [0, 2, 4, 6, 8, 10] 

**\#find** - Alias for detect.

**\#find_all** - Alias for select.

**\#find_index** - returns an integer. Similar to detect (and find), but finds the *index* of the first item that matches the block.

    > a = ['zero', 'one', 'two', 'three']
     => ["zero", "one", "two", "three"] 
    > a.find_index {|num| num == 'two'}
     => 2

**\#first** - returns an object, or nil, or an array of objects, does not change original collection. Returns either object or nil if you just want the first, returns an array if you are asking for the first(n) elements.

    > a = [1,2,3,4,5]
     => [1, 2, 3, 4, 5] 
    2> a.first
     => 1 
    > a.first(3)
     => [1, 2, 3] 
    > a = []
     => [] 
    > a.first
     => nil 
    > a.first(2)
     => [] 

**\#grep** - returns a new collection, does not change original collection. Looks for patterns in a collection.

    > a = []
     => [] 
    > a_methods = a.methods
     => !!!there are 169 methods listed here!!!
    2.1.1 :108 > a_methods.grep(/ect/)
     => [:inspect, :collect, :collect!, :select, :select!, :reject, :reject!, :detect, :collect_concat, :inject, :each_with_object, :protected_methods, :object_id]

**\#include?** - returns true or false. Similar to detect but does not return the object.

    > a = [1,2,3,4,5]
     => [1, 2, 3, 4, 5] 
    > a.include?(4)
     => true 
    > a.include?(9)
     => false 

**\#inject** - returns an object (usually one thing). There are many permutations of this method as the method can receive the following: initial, symbol, memo, block. The initial tells inject what value to start with, the symbol can tell the method how to transform the data, memo "collects" a value or values. NOTE!!! Whatever is returned at the end of the block is the new "memo". Examples might be better than explanations. **Alias: reduce.**

    > a = [1,2,3,4,5]
     => [1, 2, 3, 4, 5] 
    > a.inject(:+)
     => 15
    > a.inject(100,:+)
     => 115
    > a.inject {|sum, num| sum + num}
     => 15 
    > a.inject(100) {|sum, num| sum + num}
     => 115 

**\#map** - Alias for collect.

**\#max** - returns one object. Returns object with maximum value. Add a block if you want to select by a non-default criteria.

    > a = [1,2,3,4,5]
     => [1, 2, 3, 4, 5] 
    > a.max
     => 5 
    > a = ['antelope','bat','chinchilla','dugong']
     => ["antelope", "bat", "chinchilla", "dugong"] 
    > a.max
     => "dugong" 
    > a.max {|x, y| x.length <=> y.length}
     => "chinchilla"

**\#max_by** - similar to max with a block.

    > a = ['antelope','bat','chinchilla','dugong']
     => ["antelope", "bat", "chinchilla", "dugong"] 
    > a.max_by {|x| x.length}
     => "chinchilla"
     
**\#member?** - Alias for <code>include?</code>

**\#min** - returns one object. Returns object with minimum value. Add a block if you want to select by a non-default criteria.

    > a = ['antelope','bat','chinchilla','dugong']
     => ["antelope", "bat", "chinchilla", "dugong"] 
    > a.min
     => "antelope" 
    > a.min {|x,y| x.length <=> y.length}
     => "bat"
     
**\#min_by** - similar to min with a block

    > a = ['antelope','bat','chinchilla','dugong']
     => ["antelope", "bat", "chinchilla", "dugong"] 
    > a.min_by {|x| x.length}
     => "bat" 

**\#minmax** - returns an array, does not alter original collection. Returns the minimum and maximum element of the collection. Add a block if you want to select by a non-default criteria. Surprisingly, the last line works as far as I can tell... that does not work on the min or max methods.

    > a = ['antelope','bat','chinchilla','dugong']
     => ["antelope", "bat", "chinchilla", "dugong"] 
    > a.minmax
     => ["antelope", "dugong"]
    > a.minmax {|x,y| x.length <=> y.length}
     => ["bat", "chinchilla"] 
    > a.minmax {|x| x.length}
     => ["bat", "chinchilla"]

**\#minmax_by** - similar to minmax with a block.

    > a = ['antelope','bat','chinchilla','dugong']
     => ["antelope", "bat", "chinchilla", "dugong"]
    > a.minmax_by {|x| x.length}
     => ["bat", "chinchilla"] 

**\#none?** - returns true or false. Opposite of any?.

    > a = ['antelope','bat','chinchilla','dugong']
     => ["antelope", "bat", "chinchilla", "dugong"]
    > a.none? { |animal| animal == 'echidna'}
     => true 
    > a.none? { |animal| animal == 'bat'}
     => false 


**\#one?** - returns true or false. Returns true only if exacty on of the elements returns true in the block.

    > a = ['antelope','bat','chinchilla','dugong']
     => ["antelope", "bat", "chinchilla", "dugong"] 
    > a.one? {|animal| animal.length == 3}
     => true 
    > a.one? {|animal| animal == 3}
     => false

**\#partition** - returns an array of two arrays, the first with all items matching true compared to the block and second with all the items matching false, does not alter original collection.

    > a = [1,'two',3,'four',5,'six']
     => [1, "two", 3, "four", 5, "six"] 
    > a.partition { |num| num.class == Fixnum}
     => [[1, 3, 5], ["two", "four", "six"]] 
    > a
     => [1, "two", 3, "four", 5, "six"] 


**\#reduce** - **Alias for inject**.

**\#reject** - returns an array, does not alter original array. Opposite of select.

    > a = [1,2,3,4,5,6]
     => [1, 2, 3, 4, 5, 6] 
    > a.reject {|num| num % 3 == 0}
     => [1, 2, 4, 5] 
    > a
     => [1, 2, 3, 4, 5, 6] 

**\#reverse_each** - exactly what you think.

    > a = [1,2,3,4,5,6]
     => [1, 2, 3, 4, 5, 6]
    > a.reverse_each {|num| p num}
    5
    4
    3
    2
    1
     => [1, 2, 3, 4, 5]

**\#select** - returns a new collection, does not change original collection. Returns an array of the items that match the block. Without a block, an Enumerator Object is returned.

    > a = [0,1,2,3,4,5]
     => [0, 1, 2, 3, 4, 5] 
    > a.select {|num| num % 2 == 0}
     => [0, 2, 4] 
    > a
     => [0, 1, 2, 3, 4, 5] 

**\#sort** - returns a new collection, does not change original collection. Returns an array of the sorted items in default order, or sorted that match the block. 
 
    > a = ['rose', 'nettles', 'oatstraw']
     => ["rose", "nettles", "oatstraw"] 
    > a.sort
     => ["nettles", "oatstraw", "rose"] 
    > a.sort {|herb| herb.length}
     => ["oatstraw", "nettles", "rose"] 
    > a.sort {|a,b| a.length <=> b.length}
     => ["rose", "nettles", "oatstraw"]

**\#sort_by** - very similar to sort, but can be less computationally expensive when sorting is more complicated, and more computationally expensive when sorting is simple.

    > a = ['rose', 'nettles', 'oatstraw']
     => ["rose", "nettles", "oatstraw"] 
    > a.sort_by {|herb| herb.length}
     => ["rose", "nettles", "oatstraw"]

**\#take** - returns a new collection, does not change the existing collection. Opposite of drop.

    > a = [0,1,2,3,4,5]
     => [1, 2, 3, 4, 5] 
    > a.take(3)
     => [1, 2, 3] 
    > a
     => [0, 1, 2, 3, 4, 5]

**\#to_a** - returns an array (possibly containing arrays).

    > (1..9).to_a
     => [1, 2, 3, 4, 5, 6, 7, 8, 9] 
    > h = {:a => 1, :b => 2, :c =>3}
     => {:a=>1, :b=>2, :c=>3} 
    > h.to_a
     => [[:a, 1], [:b, 2], [:c, 3]] 
    > h
     => {:a=>1, :b=>2, :c=>3}

**\#to_h** - returns a hash, does not alter original collection. Needs an array pair for the key and value.

    > a = [:a,:b,:c]
     => [:a, :b, :c] 
    > a.each_with_index.to_h
     => {:a=>0, :b=>1, :c=>2} 
     
    > aa = [[1,:a],[2,:c],[3,:c]]
     => [[1, :a], [2, :c], [3, :c]] 
    > aa.to_h
     => {1=>:a, 2=>:c, 3=>:c} 
    > aa
     => [[1, :a], [2, :c], [3, :c]]

**\#zip** - returns an array of arrays. Final array length will be the length of the longest array, and any mismatches of array.

    > a = ['rose', 'nettles', 'oatstraw']
     => ["rose", "nettles", "oatstraw"] 
    2.1.1 :038 > b = ['licorice', 'chickweed', 'mugwort']
     => ["licorice", "chickweed", "mugwort"] 
    2.1.1 :039 > a.zip(b)
     => [["rose", "licorice"], ["nettles", "chickweed"], ["oatstraw", "mugwort"]] 

### [Check it out on Ruby Doc!](http://www.ruby-doc.org/core-2.1.1/Enumerable.html)