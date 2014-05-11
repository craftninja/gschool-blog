---
title: Making a Timer in Ruby
date: 2014-04-14 03:00 UTC
tags: pomodoro, ruby, coding, catsup
---

Did you know that your computer can talk to you? Try pasting the below code into your terminal...

    $ say -v "Cellos" "Emily Platzer Makes Things is totes awesome, yo"

What the what? So cool, right? Mess around with that for a bit, and try pasting the following monster line of code into IRB to sample all the voices on your computer...

    \> `say -v ?`.split(/\n/).map{|l| l[0, l.index('en_')].strip}.each{|v| puts v; %x[say -v \"#{v}\" \"I am #{v}\"]; sleep(0.5) }

OMG how do you choose!?!

We were given a little challenge this week to make a pomodoro timer, optionally using these voices. [The "pomodoro" technique](http://en.wikipedia.org/wiki/Pomodoro_Technique) is breaking up work time into 30 minute pieces... 25 minutes of work, 5 minute break. It is thought that this rhythm helps with productivity. I really like using it, both in class and while studying. However, so many of the available apps are not that great, or are both not great and cost a bit of money. So let's make one!

Shall we?

First we need to create a project folder, cd into it, and make a file to write our code.

    $ mkdir catsup_timer
    $ cd catsup_timer
    $ touch catsup_timer.rb

Which text editor do you like to use? Open that rb file you just created into your text editor of choice and lets get cracking. First we will note the current time, then wait for 25 minutes and then have the computer tell us that the time is up. Lets find out what happens when we add 25 to the current time.

    start_time = Time.now
    end_time = start_time + 25
    puts start_time
    puts end_time

Oh dear, that only added 25 seconds to our time... Guess we will have to convert our minutes into seconds also.

    minutes = 25
    start_time = Time.now
    seconds = minutes * 60
    end_time = start_time + seconds 
    puts start_time
    puts end_time

Lets just extract that minute variable too. We might want to change the amount of time later, and a variable might help us with that. Ok, running that code looks like it will work for timing our pomodoro session. Lets make a loop that will keep looping for that 25 minutes. Aaaactually, since we are in test mode, lets set our minutes at the top to <code>0.2</code> minutes. We don't want to keep waiting 25 minutes for our test scenario to run!

    minutes = 0.2
    start_time = Time.now
    seconds = minutes * 60
    end_time = start_time + seconds 
    while Time.now < end_time
    end
    puts "It's Over!"

Sweet! That looks like it is working. Where should we go from here? A voice, you say?

    minutes = 0.2
    start_time = Time.now
    seconds = minutes * 60
    end_time = start_time + seconds 
    while Time.now < end_time
    end
    system(%Q{say -v "Vick" "Your tomato has exploded. Time is up."})

What the hex? What is that last line? Well, the whole <code>system ()</code> thing are instructions _from ruby_ for your _terminal_ to follow. The <code>%Q{}</code> thing is a fancy way of saying, hey lets put double quotes around this whole thing here. That way you can use double quotes inside. The <code>say</code> is telling your computer to actually speak the words that are following, the <code>-v "Vick"</code> is saying, oh yeah, and I wanna pick a specific voice for this, and finally the last part is the phrase you would like your computer to say. Whew!

Did you run it? How did it go?

Ok, so we have something pretty cool here, but I think perhaps we shouldn't assume you only want a 25 minute interval. Lets update this so we ask a user for how many minutes we want to set the pomodoro for.

    puts "Welcome to the Catsup Timer. How many minutes would you like me to set for you?"
    minutes = gets.chomp
    start_time = Time.now
    seconds = minutes * 60
    end_time = start_time + seconds 
    while Time.now < end_time
    end
    system(%Q{say -v "Vick" "Your tomato has exploded. Time is up."})

Well that didn't work. Did you look at the error? Something about converting a string into a number? Look at that second line. That <code>gets</code> method assumes that inputs are String. But we want that to be a number... just tack on the method <code>.to\_i</code> and all will be well. Although that means we cannot put in decimals for minutes... <code>.to\_i</code> will convert a Float into a Fixnum and turn <code>0.2</code> minutes into zero minutes... which is really alright for testing. But our timer will now do a minimum of 1 minute.

    puts "Welcome to the Catsup Timer. How many minutes would you like me to set for you?"
    minutes = gets.chomp.to_i
    start_time = Time.now
    seconds = minutes * 60
    end_time = start_time + seconds 
    while Time.now < end_time
    end
    system(%Q{say -v "Vick" "Your tomato has exploded. Time is up."})

Lets get a little crazy... lets have our dear friend Vicky announce that first line, and <code>puts</code> that last line. Also, so we aren't burning up that dear sweet CPU, lets have the computer only check every second to see if time is up.

    welcome_message = "Welcome to the Catsup Timer. How many minutes "
    welcome_message += "would you like me to set for you?"
    puts welcome_message
    system(%Q{say -v "Vick" #{welcome_message}})
    minutes = gets.chomp.to_i

    start_time = Time.now
    seconds = minutes * 60
    end_time = start_time + seconds

    while Time.now < end_time
      sleep 1
    end

    puts "Your tomato has exploded. Time is up."
    system(%Q{say -v "Vick" "Your tomato has exploded. Time is up."})

Whoa! More new weirdness! So now we extracted that <code>welcome\_message</code>, and since it was so long we did a special <code>+=</code> method to just concatenate that big boy. It also makes it much easier to change if we decide to do that. And since we have a variable holding that string for Vicky to say, we can "interpolate" that string in line 4. To do this, our string needs to be in double quotes, which we have magically done with the <code>%Q{}</code>. Then, within that string, we put the variable inside of <code>#{}</code>. Kinda magic! The sleep command does what you think... just a little 1 second rest for your sweet CPU. And look how nice that spacing is... much more readable.

Oh and did you run that little baby? Sweeeeet! Looks like a great time to commit to Git and share!

    $ git init
    $ git status
    $ git add -N catsup_timer.rb
    $ git add -p catsup_timer.rb

Make sure your code is looking fresh!

    $ git status
    $ git commit -m "User can set a pomodoro timer with specified time"
    $ git status

####Possible future iteration ideas:

+ Extract that last line into a "time's up" variable
+ Ensure that any inputs are sensical (turning a phrase into an integer is just silly)
+ Have a countdown timer show in terminal
+ Choose units of time (seconds, minutes, hours)
+ Choose your "time's up" or "welcome" phrase
+ Choose a voice
+ Create two timers at the beginning, one for the work (25 min?) and one for the break (5 min?). The second autostarts after completion of the first timer.

### Mad props to [Jeff Dean](http://www.jeffmdean.com/)

+ for being an all around badass
+ and also for sending his gStudents that monster second line of code up there
+ and for assigning the "little terminal pomodoro" challenge
+ it was done in a pomodoro, btw, ftw. Mine definitely was not this simple after 25 min... what a rambling mess. No, I can't show you. It was hidden between commits. And kinda gross.

### [Check it out on GitHub!](https://github.com/craftninja/blog_catsup_timer)