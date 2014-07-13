---
title: So Totally Random
date: 2014-07-14 03:00 UTC
tags: ruby, rspec, random
---

I keep hearing that testing randomness is really hard. Maybe I got the insider scoop too quickly.. it's totally easy! I'll show you some cool tricks to make totally random totally your ally.

Let's make a little dice game that we can play with. How an oversimplified game of [10,000](http://en.wikipedia.org/wiki/Dice_10000)? Let's say the rules are:

  * 1's are 100 points
  * 5's are 50 points

That sounds like plenty of rules for a simple game... you can even level it up later to a full fledged game if you want. Let's fork and clone the repo from a previous blog post, [Test Driving with RSpec](http://www.emilyplatzer.io/2014/04/21/basic-ruby-rspec.html) ([Github repo link](https://github.com/craftninja/blog_dice_roller)). I added a tag to that starting commit to the repo being built along with this post called <code>random\_testing\_start</code>.

Now, we will make a new class that will run our game. Of course we start by writing our tests. Create a new file in the spec directory <code>game\_turn\_spec.rb</code>, and put the following inside:

    require 'game_turn'
    
    describe GameTurn do
      it 'initializes the game with current score 0' do
        game_turn = GameTurn.new
        actual = game_turn.score
        expected = 0
        expect(actual).to equal(expected)
      end
    end

Follow the failing tests to implement code, and you may end up with something like this:

    class GameTurn
      
      attr_reader :score
      
      def initialize
        @score = 0
      end
      
    end

By the way, the code <code>attr_reader :score</code> is functionally identical to the following code within the class:

    def score
      @score
    end

Commit, and let's write the next test. Our pre-existing DiceRoller is initialized with 6 sides, so that works for us. Now the spec file will look like this:

    require 'game_turn'
    
    describe GameTurn do
    
      it 'initializes the game with current score 0' do
        game_turn = GameTurn.new
        actual = game_turn.score
        expected = 0
        expect(actual).to equal(expected)
      end
    
      it 'allows user to roll dice and score them' do
        game_turn = GameTurn.new
        actual = game_turn.roll(6)
        expected = "You rolled [1, 2, 3, 4, 4, 6] for 100 points."
        expect(actual).to eq(expected)
      end
    
    end

And we will go straight to code implementation for our lib file to look like this (for more about proper TDD/BDD please see [this blog post](http://www.emilyplatzer.io/2014/04/21/basic-ruby-rspec.html)):

    require_relative 'dice_roller'
    
    class GameTurn
    
      attr_reader :score
    
      def initialize
        @score = 0
        @dice = DiceRoller.new
      end
    
      def roll(num_dice)
        rolled = @dice.roll(num_dice).sort
        points = rolled.count(1) * 100
        "You rolled #{rolled} for #{points} points."
      end
    
    end

Now if you run the test, you will notice that each time we run that test, we get a different roll. Let's "rig" the game by making sure we roll the same thing every time. We will "seed" the random number generator so we get the same results every time, and then "un-seed" it with <code>srand(Random.new_seed)</code>. Now the second test in our spec file will look like this:

    it 'allows user to roll dice and score them for the 1s' do
      srand(1)
      game_turn = GameTurn.new
      actual = game_turn.roll(6)
      expected = "You rolled [1, 2, 3, 4, 4, 6] for 100 points."
      expect(actual).to eq(expected)
      srand(Random.new_seed)
    end

If you run this test a few times, you will see that you keep getting the same roll. But it's not really what we wanted... How do we find the correct seed to get this roll? Let's add a new "test" below the one above:

    it 'finds a certain roll' do
      actual_roll = ""
      i = 0
      while actual_roll != "You rolled [1, 2, 3, 4, 4, 6] for 100 points."
        srand(i)
        game_turn = GameTurn.new
        actual_roll = game_turn.roll(6)
        p "srand #{i} - #{actual_roll}"
        i+=1
      end
    end

When you run this "test", you will get a print out of all the seeds and rolls until the one you are wanting gets printed. Use this seed in your test above. I do like printing everything, as sometimes you accidentally forget something and get an infinite loop and can see that you are going nowhere... and you can see how to change your code to get it right. DON'T forget the awesome command CTRL-C for stopping a process... it is necessary in those cases of accidental infinite loop. 

My seed was 118... what is yours? Let's add that seed to our test and run the test again, commenting out our "seed finder". Pass! Let's commit and write our next test.

    it 'allows user to roll dice and score them for the 1s and 5s' do
      srand(1)
      game_turn = GameTurn.new
      actual = game_turn.roll(6)
      expected = "You rolled [1, 2, 3, 5, 5, 6] for 200 points."
      expect(actual).to eq(expected)
      srand(Random.new_seed)
    end

Change the roll method to:

    def roll(num_dice)
      rolled = @dice.roll(num_dice).sort
      points = rolled.count(1) * 100 + rolled.count(5) * 50
      "You rolled #{rolled} for #{points} points."
    end

Run that test, which will MOST LIKELY not pass. To find the proper seed, uncomment the 'finds a certain roll' test, replace the roll with what you are looking to find, and get that seed. My seed was 121... comment the seed finder back out and run all your tests. Pass! Commit, and try your little scorer in the terminal.

    ± |master ✗| → irb
    2.1.1 :001 > require_relative 'lib/game_turn.rb'
     => true 
    2.1.1 :002 > game=GameTurn.new
     => #<GameTurn:0x007fbe7b9e4d00 @score=0, @dice=#<DiceRoller:0x007fbe7b9e4cb0 @sides=6>> 
    2.1.1 :003 > game.roll(6)
     => "You rolled [1, 1, 1, 2, 4, 5] for 350 points." 
    2.1.1 :004 > game.roll(2)
     => "You rolled [5, 5] for 100 points." 
    2.1.1 :005 > game.roll(6)
     => "You rolled [1, 3, 5, 5, 5, 6] for 250 points."

I think I'll stay. Your turn!

##### Great tips:
* Testing is often run in random order. 
* Make sure and seed each test individually, and reset the seed after.

### [Check it out on GitHub!](https://github.com/craftninja/blog_dice_random_testing)
