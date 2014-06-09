---
title: Hone your Mad Git (and Terminal) Skillz - Episode 1
date: 2014-06-09 03:00 UTC
tags: git
---

If you have traveled a bit with me thus far, I may have exposed you to many different Git commands. Lets work through a pretty extensive overview of Git.

Let me start by recommending this video. This will give you a pretty solid understanding of the basic architecture of git commits and how they can relate to each other.

<iframe width="640" height="480" src="//www.youtube.com/embed/1ffBJ4sVUb4" frameborder="0" allowfullscreen></iframe>

Git is a version control system. That means that Git can record "versions" of a project as many times as you want. It does back up all your files, but also backs up each change you make when you tell it to do so. So if you are working on controversial album art for a music project you are working on, you can save each little change made, and if you decide that you want to go back to how you had it in the beginning, you just check out that commit. Or if you want to see who was responsible for a certain image being added, you can see that information too.

Git is also distributed, and is often called a "distributed version control system". That means that in addition of the above, the entire project history and log and contents and everything can be distributed on several computers in different places. You have your project up on GitHub (which is totally amazing and we will talk exactly about that next time), you have that project local on your computer, and your good friends Steve, Eric and Ginger have local versions on their machines too. So if you spill a delicious Rose Kombucha all over your computer, your entire project isn't lost. You will need to get another computer and set it up, but then you just fetch and merge changes from other repositories (where you have that project saved as a Git project). Each repository has the entire contents of the project including all the history so you don't lose a thing, as long as you are active in "pushing" your changes.

Now it's your turn! Lets start by making a directory, cd'ing into it, and initializing an empty git repository.

    $ mkdir blind_faith
    $ cd blind_faith
    $ ls -l
    $ ls -al
    $ git init
    $ ls -l
    $ ls -al

You might have seen that <code>ls -l</code> lists your files and directories, and <code>ls -al</code> lists all those plus hidden files and directories. Oooh, look, a new hidden directory <code>.git</code>. What is it?

    $ cd .git
    $ ls -al

Whoa, look at all that stuff! Those are the Git internals... the pieces that keep track of all your work and ordered history. Let's definitely not mess with any of this stuff. Unless of course you accidentally initialize a git repo... if that ever happens just delete this <code>.git</code> directory.

    $ cd ..

We should be right back in our <code>blind_faith</code> folder. Let's put a text file in there.

    $ touch cant_find_my_way_home.txt
    $ ls -l
    $ echo Come down off your throne and leave your body alone. >> cant_find_my_way_home.txt

The echo line is appending (placing it at the end) the text between <code>echo</code> and <code>>></code> into the file <code>cant\_find\_my\_way\_home.txt</code>. Since it is an empty file, it just puts it in there. If you now open the file in your text editor, you can see that that text has been added. Let's commit this!

    $ git status
    $ git add cant_find_my_way_home.txt
    $ git status
    $ git commit -m "Can't find my way home - line 1"

Great! Let's make another commit.

    $ echo Somebody must change. >> cant_find_my_way_home.txt
    $ git add -p

This is another way of adding changes to be committed. The <code>-p</code> flag allows you to approve "patches" of code. You then can sequentially go through each patch or hunk and selectively approve them. For each hunk, these are commands most used:

  * y - __Y__es, stage it
  * n - __N__o, don't stage this one, but show me the next hunk.
  * q - __Q__uit, don't stage this one and skip all the rest too.
  * a - __A__ll of the rest. Stage this one and the rest of the hunks too.
  * d - __D__on't stage any of the hunks in this specific file.

Approve the second line with a <code>y</code>. If you would like a full list of commands available, enter <code>git add --help</code> and press the spacebar to page down. Enter <code>q</code> to exit the help. Let's commit this change.

    $ git status
    $ git commit -m "Can't find my way home - line 2"
    $ echo You are the reason I've been waiting so long. >> cant_find_my_way_home.txt
    >

Oh no! What is happening? Well, check that single quote up there... terminal is thinking that you are putting things in quotes. Any time terminal gives you that little caret thingie, it is waiting for more information. Let's control+C to terminate this command and try again.

    $ echo "You are the reason I've been waiting so long." >> cant_find_my_way_home.txt

Better! If you have single quotes in a string, be sure and double quote the entire string to avoid trouble. And another commit.

    $ git status
    $ git add -p
    $ git commit -m "Can't find my way home - line 3"
    $ git status

Did you see how the <code>git add -p</code> shows you exactly what line is added with the little <code>+</code> symbol? You also are shown the context of that added line to help jog your memory of what that line is doing there and how it relates to the rest of your files. Let's see what we have so far.

    $ git log --oneline --decorate --graph --all

You can see our most recent commit at the top with the tags <code>HEAD</code> and <code>master</code>. Our main branch is always called <code>master</code> and wherever it is we are currently standing (mostly) is called <code>HEAD</code>. Let's make a new branch to see what that looks like.

    $ git checkout -b winwood
    $ git status
    $ git log --oneline --decorate --graph --all

That first command does two things, it creates a branch (due to the <code>-b</code> flag) named winwood, then checks out that branch. When you run <code>git status</code> you can see that you are in that <code>winwood</code> branch. And running that log will show you all your tags again... looks like our new <code>winwood</code> tag is right there along with the <code>master</code> and <code>HEAD</code>. Let's add some more!

    $ echo Somebody holds the key. >> cant_find_my_way_home.txt
    $ git add -p
    $ git status
    $ git commit -m "Can't find my way home - line 4"
    $ git log --oneline --decorate --graph --all

Oh, look at that. Looks like we left master behind. One more commit.

    $ echo "But I'm near the end and I just ain't got the time" >> cant_find_my_way_home.txt
    $ git add -p
    $ git status
    $ git commit -m "Can't find my way home - line 5"
    $ git log --oneline --decorate --graph --all

Now Eric, Ginger and Ric are giving the thumbs-up to Steve on the new lyrics addition. Let's merge our two commits on our branch into our master branch. First order of business will be to "stand" in the branch we want to merge into. We want to merge <code>winwood</code> INTO <code>master</code>, so we will need to checkout master.

    $ git checkout master
    $ git log --oneline --decorate --graph --all

As you can see, our <code>HEAD</code> tag and our <code>master</code> tag are now on the same line. Also, if you run <code>git status</code> again, you will see we are checking out our <code>master</code> branch. Now on to merging. Look at that git log again... see how <code>master</code> is a direct "parent" of <code>winwood</code>? This will be a "fast-forward" merge... we don't need to do anything special for this merge, we just need to move that <code>master</code> tag up to the <code>winwood</code> tag.

    $ git merge winwood
    $ git log --oneline --decorate --graph --all

As you can see, git told you that it did a "fast-forward" merge. This means all git has to do to merge the old commit with the new is move a tag because the old is a direct descendant of the new. Let's imagine that Steve and Eric are both working on this album at the same time. First, let's make a change in the master branch. We should be in the master branch, but run <code>git status</code> if you ever need to check.

    $ echo "And I'm wasted and I can't find my way home." >> cant_find_my_way_home.txt
    $ git add -p
    $ git status
    $ git commit -m "Can't find my way home - line 6"

Now we will go back to our <code>winwood</code> branch and add a new song.

    $ git checkout winwood
    $ touch had_to_cry_today.txt
    $ echo "It's already written that today will be one to remember" >> had_to_cry_today.txt
    $ git add -p

Uh oh, we can't <code>git add -p</code> because this is a new file. Let's add this as a file that git should track, but not add any hunks of code.

    $ git add -N had_to_cry_today.txt
    $ git add -p
    $ git status
    $ git commit -m "Had to cry today - line 1"
    $ git log --oneline --decorate --graph --all

Cool! Check out that forking graph! But now <code>master</code> is not a direct descendant of <code>winwood</code>... how is git going to merge things now?

    $ git checkout master
    $ git log --oneline --decorate --graph --all
    $ git merge winwood
    :q

A screen should pop up with a commit message of "Merge branch 'winwood'", and this is totally sufficient. You can close this screen by pushing <code>:q</code> and enter, and it will save that message. This time, we didn't just fast-forward with our merge, we actually made a new commit combining the two commits. Since there are no merge conflicts, git could totally handle this without any help. Yay git! Now onto merge conflicts... we should be in the branch master.

    $ echo "I'm not really sure what to say here..." >> had_to_cry_today.txt
    $ git add -p
    $ git commit -m "Had to cry today - line 2???"
    $ git checkout winwood
    $ echo "The feeling's the same as being outside of the law" >> had_to_cry_today.txt
    $ git add -p
    $ git commit -m "Had to cry today - line 2"
    $ git log --oneline --decorate --graph --all

That graph is getting pretty interesting! And we made changes on the same line in the same file... what will git do now?

    $ git checkout master
    $ git log --oneline --decorate --graph --all
    $ git merge winwood

Oh no! A merge conflict in <code>had\_to\_cry\_today.txt</code>! No worries, this kind of thing happens. Lets open that up in our text editor.

    It's already written that today will be one to remember
    <<<<<<< HEAD
    I'm not really sure what to say here...
    =======
    The feeling's the same as being outside of the law
    >>>>>>> winwood

Ok, so we just delete and edit until the file is right. I'm with Winwood on this one, let's delete the rest so the file looks like this:

    It's already written that today will be one to remember
    The feeling's the same as being outside of the law

Nice! Now we let Git know that we are done editing that merge conflict.

    $ git status
    $ git add had_to_cry_today.txt
    $ git status
    $ git commit
    :q

Again, you can save that auto-generated commit message by just entering <code>:q</code> and enter.

    $ git log --oneline --decorate --graph --all

Whew! That's a lot of Git action! Stay tuned and next week we will cover more esoteric Git commands for mastery and fun and confidence!

### [Check it out on GitHub!](https://github.com/craftninja/blog_blind_faith)
