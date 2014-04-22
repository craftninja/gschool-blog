---
title: Test Driving with Rspec
date: 2014-04-21 03:00 UTC
tags: ruby, programming, rspec, dice, 10000, tenthousand, DiceRoller
---

[Oh Hai!](http://www.youtube.com/watch?v=QvxdDDHElZo)

Lets write some classes from scratch using rspec. This is great way to start learning about definition of classes and test driven development. We will start by making a directory, cd-ing into it, initializing a git repository, initializing bundler, putting some gems in our gemfile, and bundling. Whew!

    $ mkdir dice_roller
    $ cd dice_roller
    $ git init
    $ bundle init

Open this project in your favorite text editor (RubyMine is really growing on me, btw) and open the Gemfile created by the bundle init. Go to [http://rubygems.org/](RubyGems), search for rspec, click on the "Exact Match" rspec, scroll down to the "Gemfile" and copy this text. Paste this line into your gemfile, delete the comments in the file, save, and run bundler.

    $ bundle install

You can just enter <code>bundle</code> instead, but for some reason I really enjoy being super specific. I also enjoy arranging jelly beans in color order before eating them in color order, so take that into consideration.

Now we will create two folders, a <code>spec</code> folder and a <code>lib</code> folder. The spec folder will house your spec files, and the lib will house your library of class files... well named! Create a <code>dice\_roller\_spec.rb</code> file in your spec folder. This file will drive the test and thus the development of your class. Lets start writing a test in that <code>dice\_roller\_spec.rb</code> file!

    describe DiceRoller do
    end

Then, in terminal, run your test on the project.

    $ rspec

Oh dear, what was that error?

    uninitialized constant DiceRoller (NameError)

Rspec doesn't know where that DiceRoller class is... at the top of the rspec file, add the following:

    require 'dice_roller'

Now we have a new error...

    cannot load such file -- dice_roller (LoadError)

Of course! We have to add that file. Make a new file in the lib directory named <code>dice\_roller.rb</code>. If you run rspec again, we still have that first error... That's because we don't have a class named <code>DiceRoller</code> in there yet. Let's add that class to the <code>dice\_roller.rb</code> file.

    class DiceRoller
    end

Oh hey, did you notice that the name of the class and the name of the file is almost the same? This is really good practice. The name of the folder will be in [snake_case](http://en.wikipedia.org/wiki/Snake_case) while the name of your class will be in [CamelCase](http://en.wikipedia.org/wiki/CamelCase). Alrighty, let's run that rspec again.

    No examples found.

Great! Looks like everything is loading correctly and we are ready to write the contents of our first test. This is the part where you start to think about what you want your brand new class to do. Lets say we want to specify the number of sides at initialization, defaulting to 6. How do the heck do we tell this to our computer?

    require 'dice_roller'

    describe DiceRoller do
      it 'initializes dice with default of six sides' do
        dice = DiceRoller.new
        actual = dice.sides
        expected = 6
        expect(actual).to eq(expected)
      end
    end

Whoa, what does all that mean? Well, there is a block of code in there after the <code>it 'stuff' do</code>, and before the first <code>end</code>. Lets walk trough that. In the first line of that block, we are instanciating a new "DiceRoller", that is: making a new instance of our DiceRoller class. We said we wanted the default number of sides to be six, so hopefully that happened at the same time. In the second line, we are saying that we want there to be an instance method on our object dice that is called sides. So our actual number of sides should match our expected, which is 6. Ok, what happens when we run rspec now?

     Failure/Error: actual = dice.sides
          NoMethodError:
            undefined method `sides' for #<DiceRoller:0x007fdc120a7468>

Looks like we did make an object which is an instance of the class DiceRoller, but we don't yet have a method for it in our <code>dice\_roller.rb</code> file. Let's make one!

    class DiceRoller
      def sides
        6
      end
    end

Now run our rspec. Yaaaay! It passed! Lets make a commit.

    $ git add Gemfile Gemfile.lock spec/dice_roller_spec.rb lib/dice_roller.rb
    $ git commit -m "User can initialize a dice, see that it has 6 sides."

But look at that code. Is that really what we meant by defaulting to 6? We really wanted to be able to put in any number of sides, but default to 6 sides if the argument wasn't listed at initialization. How can we write another test to "make sure" we are writing the right code?

    require 'dice_roller'

    describe DiceRoller do
      it 'initializes dice with default of six sides' do
        dice = DiceRoller.new
        actual = dice.sides
        expected = 6
        expect(actual).to eq(expected)
      end

      it 'initializes dice with 12 sides' do
        dice = DiceRoller.new(12)
        actual = dice.sides
        expected = 12
        expect(actual).to eq(expected)
      end

    end

And let's run rspec. Oh no, everything is ruined! What did our error say?

    Failure/Error: dice = DiceRoller.new(12)
         ArgumentError:
           wrong number of arguments (1 for 0)

Looks like we have an argument error. What does this mean? Well, we never wrote a def initialize method. Lets do that.

    class DiceRoller
      def initialize(sides = 6)
      end

      def sides
        6
      end
    end

Great! So now, the second we instanciate a new DiceRoller class we get the number of sides... either by specifying them or by defaulting to six. What does rspec say?

    Failure/Error: expect(actual).to eq(expected)

           expected: 12
                got: 6

           (compared using ==)

Oh yeah, we totally hardcoded that sides method. Lets have sides get it's number of sides from when we instanciate the object.

    class DiceRoller
      def initialize(sides = 6)
        @sides = sides
      end

      def sides
        @sides
      end
    end

What the heck is that @ thingie? Well, to access that "sides" variable, it cannot be an local variable. An instance variable works great for this. How is our rspec test now?

    ..

    Finished in 0.00098 seconds
    2 examples, 0 failures

Looks great! See those two dots? They are our passing tests, one dot for the first test and one for the second. Our code is coming right along, and we have passing tests. Lets do another commit!

    $ git add Gemfile Gemfile.lock spec/dice_roller_spec.rb lib/dice_roller.rb
    $ git commit -m "User can initialize a DiceRoller with a stated number of sides."

We also want to have a method called "roll" along with a argument that says how many dice we want to roll. We should get an array of results from our roll, never less than 1, never more than the initialized face number. Lets write this test!

    it 'can roll a 6 dice' do
      dice = DiceRoller.new
      roll = dice.roll(6)
      actual = roll.size
      expected = 6
      expect(actual).to eq(expected)
    end

Our error from rspec shouldn't be too surprising. There is not yet a method <code>.roll</code> for our instance of the object <code>DiceRoller</code>. And oh, look! the object is telling us it has 6 sides!

    Failure/Error: roll = dice.roll(6)
      NoMethodError:
        undefined method `roll' for #<DiceRoller:0x007feee1936160 @sides=6>

Your object location information will look a little different as it is a different object... in fact, if you run rspec again and compare that [hexidecimal](http://mathworld.wolfram.com/Hexadecimal.html) location to the previous, you will see that each object gets it's on place. Lets define that new method <code>roll</code>.

    def roll
    end

Running rspec now, we get the not enough arguments error... let's put an argument in there.

    def roll(number_dice)
    end

Sensing a pattern? Create the spec well enough, and it will tell you exactly what you do next. The next error is interesting...

    Failure/Error: actual = roll.size
      NoMethodError:
        undefined method `size' for nil:NilClass

What does that mean? Well, we were expecting the method <code>.roll</code> to give us an array of numbers (ranging from 1 to the max number of sides). Then we were wanting to measure the size of that array. Well, apparently <code>.size</code> doesn't work too well on <code>nil</code>. Which is apparently what the method <code>roll</code> currently returns. Lets give <code>.size</code> something to chew on.

    def roll(number_dice)
      [1,2,3,4,5,6]
    end

And all at least *looks* right in the world! The method <code>.size</code> has something to work with, rspec is happy, and we are ready to write more tests. Lets write some that forces us to actually make code that works. We will add another few tests... one that forces us to roll an exact number of dice, and two that makes sure we get random numbers only from 1 to the number of sides specified.

    it 'can roll a 4 dice' do
      dice = DiceRoller.new
      roll = dice.roll(4)
      actual = roll.size
      expected = 4
      expect(actual).to eq(expected)
    end

    it 'generates random numbers from 1 to 6' do
      dice = DiceRoller.new
      roll = dice.roll(100)
      actual = roll.minmax
      expected = [1,6]
      expect(actual).to eq(expected)
    end

    it 'generates random numbers from 1 to 9' do
      dice = DiceRoller.new(9)
      roll = dice.roll(200)
      actual = roll.minmax
      expected = [1,9]
      expect(actual).to eq(expected)
    end

So now we *really* can't hard code that roll method. Since we are 'testing' the random number generation and then making sure those dice only go from 1 to the number of sides, I had rspec roll 100 or 200 dice at a time. That way, the chances of rolling the minimum and maximum number is VERY high, and we can make sure that we don't roll something that doesn't make sense. Run rspec again get a "good fail", and let's write that method for the real.

    def roll(number_dice)
      roll_result = Array.new
      number_dice.times do
        roll_result << rand(1..@sides)
      end
      roll_result
    end

Lets break it down! We want to generate a random number and save it exactly <code>number\_of\_dice</code> times. We do have to set up the <code>roll\_result</code> as an <code>Array</code> object before we just start shoveling things in there. And the rspec tests look great! Let's commit this thing!

    $ git add lib/dice_roller.rb spec/dice_roller_spec.rb
    $ git commit -m "User can roll an exact number of dice."

Hmmmm... should we make it so that if we don't specify the number if dice, it defaults to one? The test is...

    it 'assumes rolling only 1 dice if not specified' do
      dice = DiceRoller.new
      roll = dice.roll
      actual = roll.size
      expected = 1
      expect(actual).to eq(expected)
    end

Run that rspec to get a "good fail", and then edit the <code>def roll</code> line as follows:

    def roll(number_dice = 1)

Rspec is happy again. Let's make one more commit.

    $ git add lib/dice_roller.rb spec/dice_roller_spec.rb
    $ git commit -m "Number of dice rolled defaults to 1."

That is a pretty good looking class! We could even use IRB to play dice now. A game of [10,000](http://en.wikipedia.org/wiki/Dice_10000)?

    $ IRB
    > require '<path to project folder>/dice_roller/lib/dice_roller.rb'
    => true
    > dice = DiceRoller.new
    => #<DiceRoller:0x007fb89b816ef0 @sides=6>
    > dice.roll(6)
    => [2, 1, 4, 6, 3, 1]

I'll keep one of the 1's for 100 pts.

    > dice.roll(5)
    => [5, 2, 1, 3, 4]

Ugh, not looking good. I'll keep another 1, total 200 pts.

    > dice.roll(4)
    => [2, 6, 1, 5]

Well, I guess I'll keep the 1 and the 5 for 350 total.

    > dice.roll(2)
    => [2, 6]

Oh! Busted. Your turn!

### [Check it out on GitHub!](https://github.com/craftninja/blog_dice_roller)

