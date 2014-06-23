---
title: Hone your Mad Git Skillz - Episode 3
date: 2014-06-23 03:00 UTC
tags: git
---

It's a Git-stravaganza!

This week we are going to cover a completely different workflow. If you traveled with me the last two weeks, you will remember that our resulting repository graph was a bit crazy... let me refresh your memory.

[<img src="/images/20140623_git_ep3/git_merge_graph.png" alt="git merge log" width="600em">](/images/20140623_git_ep3/git_merge_graph.png)

Wow, look at all those lines merging and diverging over and over... There is another workflow we can use where the master branch will result in a straight line. Let's try it! We will start with a fresh clean repo. Look up a fun song to inspire your text file, or follow along with my text changes. REMEMBER - Rebasing commits that have been pushed to a remote repo is TERRIBLY BAD MANNERS. Don't do it. ONLY rebase commits that are EXCLUSIVELY local.

Here we will set up our local git repo and make three little commits. We will be using the <code>echo</code> terminal command again this week, which will add the text after the command and before the double caret <code>>></code> to the end of the file specified after the <code>>></code>.

    $ mkdir rebase_workflow
    $ cd rebase_workflow
    $ git init
    $ touch ghetto_superstar.txt
    $ echo Ghetto superstar, that is what you are >> ghetto_superstar.txt
    $ git add -N ghetto_superstar.txt
    $ git add -p
    $ git commit -m "Initial commit - Ghetto Superstar: line 1"
    $ echo "Comin' from afar, reachin' for the stars" >> ghetto_superstar.txt
    $ git add -p
    $ git commit -m "Ghetto Superstar: line 2"
    $ echo Run away with me to another place >> ghetto_superstar.txt
    $ git add -p
    $ git commit -m "Ghetto Superstar: line 3"
    $ git log --oneline --decorate --graph --all

I do have a couple of comments regarding the above code. You will notice that <code>echo</code> does not need quotes around it unless there are quotes in the text... you definitely want to use double quotes if you have single quotes in your text string, and single quotes if you have double quotes in your text string. If you have both, use double quotes on the outside and escape any interior double quotes.

    $ echo 'this is a "thing"'
    $ echo "this is a 'thing'"
    $ echo "this 'thing' is a \"thing\""

In addition, the <code>git add -N \<filename\></code> adds a specified new file to be tracked by git, but does not stage any code in that file. The <code>git add -p</code> adds patches of code one by one to be approved by you for staging in any file that is already being tracked by git. The command <code>git log</code> has many many flags available to help you see the history of your repository. They can be added in any order, and the four above flags are some of my favorites. In fact, I added this command with flags in my root directory's <code>.gitconfig</code> file. Although you totally look like a badass if you just type out that whole line, here is what I added to my <code>.gitconfig</code> file:

    [alias]
            loggy = log --oneline --decorate --graph --all

If you want to make more aliases, please remember as soon as you pair on someone else's computer, you will be a sadface. Also, be sure the alias word you choose does not exist as a real command! Making an alias called "commit" would be a terrible idea.

Alright, ghetto superstar. You are now going to write some lyrics on a separate branch from master, and then bring them back into master once we are ready. We are going to make a branch, make some commits, and then rebase them back into the <code>master</code> branch. Let's do it!

    $ git checkout -b rough_draft
    $ echo We can rely on each other, uh huh >> ghetto_superstar.txt
    $ git add -p
    $ git commit -m "Ghetto Superstar: line 4"
    $ echo From one corner to another, uh huh >> ghetto_superstar.txt
    $ git add -p
    $ git commit -m "Ghetto Superstar: line 5"
    $ git log --oneline --decorate --graph --all

You can see that this really is a straight line... let's add a commit to <code>master</code> so that a simple fast forward merge would not work.

    $ git checkout master
    $ touch shimmy_shimmy_ya.txt
    $ echo Shimmy shimmy ya, shimmy yam, shimmy yay, >> shimmy_shimmy_ya.txt
    $ git add -N shimmy_shimmy_ya.txt
    $ git add -p
    $ git commit -m "Shimmy Shimmy Ya: line 1"
    $ git checkout rough_draft
    $ git log --oneline --decorate --graph --all

Before we commit, we will tag our branch. Normally this isn't really necessary, but if we don't tag it we will lose all pointers to that end commit, and it will be orphaned and eventually cleaned up by git. If we tag it, there will be a pointer to that end commit and it will stick around so we can really see what is happening there and learn how git does these sort of operations.

    $ git tag pre-rebase1
    $ git log --oneline --decorate --graph --all

[<img src="/images/20140623_git_ep3/rebase01-pre.png" alt="pre rebase1" width="600em">](/images/20140623_git_ep3/rebase01-pre.png)

Now we will rebase all our changes and commits from this <code>rough_draft</code> branch ONTO the end of our <code>master branch</code>. The <code>master</code> branch tag will not move, but we will take all the changes in our branch and apply them to the end of our <code>master</code> branch. This will happen in one fell swoop (unless there are merge commits, which there are not), but each commit will still be a separate commit (unless you specify otherwise).

    $ git rebase master
    $ git log --oneline --decorate --graph --all

[<img src="/images/20140623_git_ep3/rebase01-post.png" alt="post rebase1" width="600em">](/images/20140623_git_ep3/rebase01-post.png)

You can see that there are new commits there on the end of the <code>master</code> branch with the same messages as our pre-rebase messages. However, look at those SHA numbers... the weird letter-number codes at the start of each commit message. Those are totally new commits. If you checkout (literally!) those SHA numbers, you will see that the pre-rebase commits do not have the Shimmy Shimmy Ya file in them. However, the rebased commits at the end of <code>master</code> DO have that new file. So they are a little different. We can actually see that by running a <code>git diff</code> on those two SHA numbers. Your numbers will be different, of course, so make sure and substitute your SHA numbers.

[<img src="/images/20140623_git_ep3/rebase01-diff.png" alt="rebase1 diffs" width="600em">](/images/20140623_git_ep3/rebase01-diff.png)

The <code>diff</code> command shows us the difference between commit <code>8e9205a</code> and <code>438711f</code>... in the case the difference is that the file <code>shimmy\_shimmy\_ya.txt</code> was added as a new file, and the line <code>Shimmy shimmy ya, shimmy yam, shimmy yay,</code> was added. Of course, that is what we added in the commit <code>5b5cb35</code> which is still the end of the master branch. Let's move that <code>master</code> tag forward to the end of our <code>rough_draft</code> branch.

    $ git checkout master
    $ git merge rough_draft

You will see that the result of the merge is a "fast-forward"... this doesn't do any fancy merging, it really just moves that <code>master</code> tag forward.

So we aren't really pushing code at this point... but what if we were? Go ahead and create a new remote repository on GitHub, grab your clone url, and we will add the remote and push up our repo as it is.

    $ git remote -v
    $ git remote add origin git@github.com:craftninja/blog_rebase_workflow.git
    $ git remote -v
    $ git push origin master

Look at that on GitHub (your repo)... in fact, click on the "branch: master" button and note that our little tag did not get pushed. That is totally fine. Now if any peekers come around, they will just see your single line of commits and think you are so perfect at everything. I mean you are, but not like that. That would be boring. I'll push my tag so you can see it, but normally you just keep that messy stuff cleaned up and not even tagged at all.

So what happens with a merge conflict? Let's find out. On your GitHub repo's version of <code>ghetto_superstar.txt</code>, add an empty line and the following line after that:

    Some got hopes and dreams! We got ways and mean

Be cool and add a blank line at the end of the file before you hit commit changes, and change the commit message to "Ghetto Superstar: line 7". I know it is the 6th line of words, but that way you can reference the line number on the side there.

Back in our local repo, let's get back to <code>rough_draft</code>.

    $ git checkout rough_draft
    $ echo "" >> ghetto_superstar.txt
    $ echo Some got hopes and dreams, we got ways and mean >> ghetto_superstar.txt
    $ git add -p
    $ git commit -m "Ghetto Superstar: line 7"
    $ echo The supreme dream team always up with the scheme >> ghetto_superstar.txt
    $ git add -p
    $ git commit -m "Ghetto Superstar: line 8"
    $ echo "From hub caps to sellin' raps, name your theme" >> ghetto_superstar.txt
    $ git add -p
    $ git commit -m "Ghetto Superstar: line 9"
    $ git log --oneline --graph --all --decorate

We now have a little string of commits that we can add to our master branch. Since we are working on a team and you are not sure if anyone has made a commit, we will first fetch and merge, then we will rebase our branch. We want to do this all in a fell swoop, so no one makes any changes between the fetch & merge and rebase & push. MAKE SURE you are merging standing in the right branch! OK go!

    $ git checkout master
    $ git fetch origin master
    $ git log --oneline --decorate --graph --all

You can see that someone DID make an addition to our master (umm... wasn't that you?). Now we will merge that into our local master. Note fetch uses the name of the remote repository <code>origin</code> and branch that we are wanting to fetch, and merge uses the local tag <code>origin/master</code>. 

    $ git merge origin/master
    
This merge will result in a fast-forward, the only merge "allowed" in this workflow. Let's tag this branch so we can examine it again post-rebase.

    $ git checkout rough_draft
    $ git tag pre-rebase2
    $ git rebase master

Oh no! What is happening? Looks like we have a merge conflict. Open the file <code>ghetto_superstar.txt</code>...

[<img src="/images/20140623_git_ep3/rebase01-merge_conflict.png" alt="rebase1 diffs" width="600em">](/images/20140623_git_ep3/rebase01-merge_conflict.png)

It looks like we need to decide what we want line 7 to look like. Edit the file to your satisfaction, save and close, and then continue the rebase by adding the fixed file (or files as the case may be) and continuing the rebase. Be sure and remove the lines with the <code><<<<<<< HEAD</code>, <code>=======</code>, and so on.

    $ git add ghetto_superstar.txt
    $ git rebase --continue
    $ git log --oneline --decorate --all --graph
    $ git checkout master
    $ git merge rough_draft
    $ git push origin master

Whew! Good thing we were quick enough that no one added anything to the origin repo! 

[<img src="/images/20140623_git_ep3/rebase02-post.png" alt="rebase1 diffs" width="600em">](/images/20140623_git_ep3/rebase02-post.png)


Here are the basic steps we just took:

1. Create a branch
1. Checkout that branch
1. Make some commits on that branch
1. Checkout master
1. Fetch and merge any commits from remote repository's master
1. Checkout branch
1. Rebase master
1. Checkout master
1. Merge branch
1. Push changes

So that is basic rebase workflow. Try it out and see what you think!

### Mad props to [Kinsey ](http://kinseyanndurham.com/)

+ for being an all around badass
+ and for introducing us to the rebase Git workflow
+ and for being such an awesome lady in code!

### [Check it out on GitHub!](https://github.com/craftninja/blog_rebase_workflow)
