---
title: Hone your Mad Git Skillz - Episode 2
date: 2014-06-16 03:00 UTC
tags: git
---

Hurray! More Git!

Last week we covered the following terminal commands:

* mkdir
* cd
* ls -a, ls -l, ls -al
* touch
* echo <text> \>\> \<filename\>

And we covered the following git commands:

* git init
* git status
* git add \<filename\>
* git commit -m "\<message\>"
* git add -p
  * y, n, q, a, d
* git log --oneline --decorate --graph --all
* git checkout -b \<NEW branch name\>
* git checkout \<existing branch name\>
* git merge \<existing branch name\>
* git add -N \<filename\>

Wow! That is a pretty great list of Git commands! But wait, there is more...

So we have an existing repository of everything we did last time. Let's start by pushing our changes up to GitHub, CD into the proper directory where you have last week's project, OR just fork, clone, and cd into [this repo right here](https://github.com/craftninja/blog_blind_faith), and skip the part where you add a remote.

    $ git status
    $ git remote -v

If you did not clone the repo and have not set up remotes yet, nothing will yield from this above command. That means if we try to fetch, pull or push, git doesn't know where to fetch from, pull from or push to regarding the remote repository. Go to GitHub an create a new repository with the same name as your local repository's project directory. Grab the SSH clone URL as we will use that to add the remote.

    $ git remote add origin git@github.com:craftninja/blog_blind_faith_ep2.git

Your remote SSH clone URL will be different than mine, with _your_ GitHub username and _your_ repo name. Now that we have added the remote, when we run <code>git remote -v</code> we will get a list of all remotes. Git will not tell you if you have __permission__ to push to these remotes, but you should be able to fetch or pull from almost any publicly available repository.

    $ git remote -v

Now you will have listed "two" remotes, identical but for the actions "fetch" and "push". Lets get our local repo up to GitHub!

    $ git push origin master

This above command tells git to <code>push</code> all of our local commits on the branch <code>master</code> to the repository known as <code>origin</code>, and lets git assume that you want to push to the <code>master</code> branch at <code>origin</code> since you are pushing your local <code>master</code> branch. It is a TERRIBLE idea to have mismatched branch names between your local and remote repositories, so this is a wonderful idea on Git's behalf.

From this point on, I will be pushing my new changes to a new repo (link at bottom of the page). That means if you want a clean slate for the start of this blog, just fork and clone the repo listed at the top.

Open your text editor and check out the state of the files. Ok! Let's write some more lyrics!

    $ echo Come down on your own and leaf your body alone. >> cant_find_my_way_home.txt
    $ git status
    $ git add -p
    $ git commit -m "Can't find my way home - line 6"

Nice! Let's check out that text file. OH no! a typo! You don't want to __leaf__ your body, you want to __leave__ your body. BEFORE YOU PUSH ANY CHANGES, lets amend our commit. Open the <code>cant\_find\_my\_way\_home.txt</code> file and edit that line from _leaf_ to _leave_. Once you are happy with the changes, save the file and...

    $ git status
    $ git add -p
    $ git log --oneline --decorate --all --graph
    $ git commit --amend -m "Can't find my way home - line 6 - revised"
    $ git log --oneline --decorate --all --graph

Waaaait... where did our regular commit go? When we amended it, we mad a new commit but kicked the previous commit "out of the lineage". Whew, our perfect history has been preserved for posterity. Also, there is no thing as perfect. Or all things are perfect. Both at the same time. AAAAnnnyway... since that commit is floating now with no reference and no "tag", git will delete it at some point during regular cleanups. However, if you would like to remind yourself that it did indeed exist and DO NOT want git to delete that commit, scroll up and find the _SHA_ number attached to that commit. Since you ran <code>git log</code> before amending that commit, you will have it somewhere above in your terminal. This is what mine looked like...

[<img src="/images/20140616_git_ep2/git_log01.png" alt="git_log" width="600em">](/images/20140616_git_ep2/git_log01.png)

So that weird number (mine is <code>56cd342</code>) is the start of an even longer number called a SHA (pronounced "shaw"). This longer SHA number is the unique commit identifier that solely is attached to this specific commit. Each commit gets its own SHA, and if you amend a commit, you actually make a totally new commit that skips the "amended" commit and is only attached to the commit before. The SHA is __never__ reassigned to a new commit. Let's grab that SHA and attach a tag to the commit so that git will keep it around for us to remember that time when we misspelled something.

    $ git checkout 56cd342
    $ git tag amended_commit
    $ git log --oneline --decorate --all --graph

Ooooh, cool! Check that out! We made the commit reappear, and now it has a new tag attached to it. Magic! Although this commit is a bit of a dead end, now it has a reference tag and will stick around forever... 

[<img src="/images/20140616_git_ep2/git_log02.png" alt="git_log" width="600em">](/images/20140616_git_ep2/git_log02.png)

... unless of course we remove that tag. Lets open up the <code>cant\_find\_my\_way\_home.txt</code> file. What do you know! We are actually peeking back in history with that checkout command. EEEnteresting. Alright, let's get rid of the evidence of bad spelling (I'll leave mine tag in for posterity in case you want to clone my file and check out the commit history).

    $ git checkout master
    $ git tag -d amended_commit
    $ git log --oneline --decorate --all --graph

Looks great! Let's add another line.

    $ echo Somebody mist change. >> cant_find_my_way_home.txt
    $ git add -p
    $ git commit -m "Can't find my way home - line 8"

Oh dear, we made another error! That's ok, we can amend that right? Let's open that file, delete that line, and...
    
    $ echo Somebody must change. >> cant_find_my_way_home.txt
    $ git add -p
    $ git commit -m "Can't find my way home - line 8 - revised"

Oh craaap. I forgot to add that amend flag. What do we do? Well, as long as we HAVE NOT PUSHED FOR REALLY REAL, we can squash those commits together. Which will really make a NEW commit, leaving those other ones hanging dangly like our <code>amended_commit</code>. Let's add a tag here so we can view the hanging dangly later.

    $ git tag squashed_commits
    $ git rebase -i

Oh my. What is happening now? We have our commits listed with the words <code>pick</code>. They are listed in order from top being oldest, bottom being newest. Since we want to squash the last commit into the second to last, remove the word <code>pick</code> from the bottom commit and add the letter <code>s</code>. You can see that git is giving you a lovely helping hand (as per usual) with all that helpful text in that view. In case you haven't used VIM before, here are some useful commands:

* i - insert (edit) mode
* esc - exit the insert (edit) mode
* dd - delete that line (only works when you are NOT in insert mode)
* :q - quit without saving (only works when you are NOT in insert mode)
* :wq - save and then quit (only works when you are NOT in insert mode)

So as we said, make sure the bottom commit has <code>s</code> or <code>squash</code> in front of it, and the one(s) above it still have <code>pick</code> in front of it. Save and quit, and then you will enter another VIM view. Choose one of these commit messages and put a <code>#</code> in front of the other, OR put a <code>#</code> in front of both and write a new commit message for your brand spanking new commit. Again, save and quit. Let's check it out!

    $ git log --oneline --decorate --all --graph

Nice! Be sure and note that the commit resulting from the squash is a totally different commit, with a totally new SHA. When you rebase, you are creating completely new commits that have never before been seen. THEREFORE, you really better not rebase anything you have pushed. That would be in poor taste. Friends might stop calling you, lovers will spurn you. Oh, and here is what that post-squashing graph looks like...

[<img src="/images/20140616_git_ep2/git_log03.png" alt="git_log" width="600em">](/images/20140616_git_ep2/git_log03.png)

Look at those hanging danglies! Let's push this to GitHub.

    $ git status
    $ git push origin master

Go to your remote repository (the repository on Github) by visiting the repo at [https://github.com/](https://github.com/), click on your profile page, click repositories, and click on your version of this repo. Click on the file "had\_to\_cry\_today.txt". We haven't added many lyrics to this file, so let's edit it from here just to mix it up. Click on "Edit" and make sure the file looks like this, and maybe an extra empty line at the end of the file... git likes it like that.

    It's already written that today will be one to remember
    The feeling's the same as being outside of the law
    Had to cry today
    Well, I saw your sign and I missed you there

Looks great! Add your commit message at the bottom "Had to cry today - lines 3 \& 4" and click "Save". Cool! Now back to our local repository (on your computer) and finish up our song "Can't find my way home." Make sure your file looks like this with that empty extra line at the bottom:

    Come down off your throne and leave your body alone.
    Somebody must change.
    You are the reason I've been waiting so long.
    Somebody holds the key.
    But I'm near the end and I just ain't got the time
    And I'm wasted and I can't find my way home.
    Come down on your own and leave your body alone.
    Somebody must change.
    You are the reason I've been waiting all these years.
    Somebody holds the key.

Nice. Let's commit this and push.

    $ git status
    $ git add -p
    $ git commit -m "Can't find my way home - lines 1-10"
    $ git log --oneline --decorate --all --graph
    $ git push origin master

What do you mean rejected? Once we changed our file in our remote repository, we need to merge those changes into our local repository before we can push again. We will have to pull those changes down in order to bring our local repository up-to-date, and then we will be able to push again.

    $ git pull origin master
    :wq
    $ git log --oneline --decorate --all --graph
    $ git push origin master
    $ git log --oneline --decorate --all --graph

Note above that when we pulled, we pulled <code>origin</code> SPACE <code>master</code>. That is because we were dealing with the remote repository that we have named <code>origin</code>, and we wanted to pull the <code>master</code> branch of that origin remote repository into our local repository, in the branch that we happen to be sitting in (you ARE in the master branch, right???) and Merge it all together. Whew! Now you can see that the <code>origin/master</code> tag is hanging out with our <code>master</code> tag and <code>HEAD</code> tag. Everything is all up-to-date!

Let's try that again, but this time we won't use the pull command. Go to the GitHub site like before and make sure your <code>had\_to\_cry\_today.tx</code> file looks like this:

    It's already written that today will be one to remember
    The feeling's the same as being outside of the law
    Had to cry today
    Well, I saw your sign and I missed you there
    
    I'm taking the chance to see the wind in your eyes while I listen
    You say you can't reach me but you want every word to be free
    Had to cry today
    Well, I saw your sign and I missed you there
    And I missed you there
    
    Had to cry today...

Don't forget that extra empty line at the bottom if you will... commit this with the message "Had to cry today - complete". Now go back to your local repository, and make sure your file <code>cant\_find\_my\_way\_home.txt</code> looks like so:

    Come down off your throne and leave your body alone.
    Somebody must change.
    You are the reason I've been waiting so long.
    Somebody holds the key.
    But I'm near the end and I just ain't got the time
    And I'm wasted and I can't find my way home.
    Come down on your own and leave your body alone.
    Somebody must change.
    You are the reason I've been waiting all these years.
    Somebody holds the key.
    
    But I can't find my way home.
    But I can't find my way home.
    But I can't find my way home.
    But I can't find my way home.
    Still I can't find my way home,
    And I ain't done nothing wrong,
    But I can't find my way home.

Go ahead and commit this, and try to push again.

    $ git status
    $ git add -p
    $ git commit -m "Can't find my way home - complete"
    $ git log --oneline --decorate --all --graph
    $ git push origin master

So rejected. 

We are not going to pull this time. Git pull is really a combination of two git commands... git fetch and git merge. So this time we are going to fetch and merge. Before we do, I want to talk about some of the commands we have used that deal with remote repositories... those commands are __push__, __pull__ and __fetch__. When you use these commands, you need to name the remote you want to push pull or fetch from, and name what branch you want to push (from the local repository), or what branch you want to pull or fetch (from the remote repository). 

When you push, git will assume that you want to push to the named remote repository's branch with the SAME NAME as the branch you are pushing... an excellent assumption. Again, it would be a TERRIBLE IDEA to name your branch one thing locally (my\_awesome\_branch) and name it another thing remotely (my\_stupid\_branch). It would be very confusing. 

When you fetch, git will just gather all the new commits from the named remote repository and list them locally. At that point, if you merge, you are no longer dealing with a remote repository but local commits that are already on your machine. We will get to that in just a sec. 

And if you pull... this is important... you gather all the commits that are in your named remote repository and you merge them into your CURRENT BRANCH. So you best be in your master branch if you are just going to go around pulling your origin master. Danger! Danger! Seriously. KNOW WHERE YOU ARE PULLING INTO.

Ok, those are some of the ways we talk to our repositories. Back to fetching and merging. We were recently rejected, in case you forgot.

    $ git fetch origin master
    $ git log --all --graph --oneline --decorate

You can list those <code>git log</code> flags in any order, by the way. Alrighty! Looks like we have some new commits that we didn't already have locally... so that's why we were rejected. Note that the tag on the commit that we want to merge with is called <code>origin/master</code>... we are about to merge with something LOCAL. The name of that thing that we want to merge with is right there, in bright red, <code>origin/master</code>. So let us merge with that! You are standing in <code>master</code>, right?

    $ git status
    $ git merge origin/master
    :wq
    $ git log --all --graph --oneline --decorate
    $ git push origin master

Oh did you make some tags you want to push, too?

    $ git push origin --tags

Success! Holy Jeez, you are a git whiz!

### [Check it out on GitHub!](https://github.com/craftninja/blog_blind_faith_ep2)