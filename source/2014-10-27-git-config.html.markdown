---
title: Git Config awesometown
date: 2014-10-27 03:00 UTC
tags: git
---

Oh haaay, remember me?

So gSchool Boulder has started a new class, and guess who are the new teaching assistants!?

[<img src="/images/20141027_git_config/luke_and_emily.jpg" alt="Emily and Luke" width="600em">](/images/20141027_git_config/luke_and_emily.jpg)

Helping the students set up their computers reminded me of how important it is to know how to access and understand your git config options. Since usually a user sets up their config options once and never checks them again, it is often forgotten shortly after computer setup. Let's revisit!

To check and see what git config variables are currently set, run this command in terminal (any directory is fine):

    $ git config --global -l

This command will list everthing set. If you don't see these variables below set somewhere in the list, you will need to set them.

    user.name=<Your Name>
    user.email=<your_email@example.com>

Here is the command to set them:

    $ git config --global user.name "<Your Name>"
    $ git config --global user.email "<your_email@example.com>"

Be sure and add the email associated with your GitHub account so you get "credit" for your commits on your GitHub front page.

If you didn't see this variable below set in your list, I would highly suggest you add it.

    core.excludesfile=/Users/<home_directory>/.gitignore_global

To set this variable:

    $ git config --global core.excludesfile ~/.gitignore_global

This allows you to make a `.gitignore_global` file in your home directory and add a list of filenames to it... any file named in this list will automatically be excluded from git tracking. Navigate to your home directory, create a file named `.gitignore_global`, and add files to be ignored. Here are a few files you might add to be ignored:

    junk.*
    .idea
    .DS_Store

So that first file allows me to create anything named junk... `junk.rb`, `junk.csv`, `junk.txt`... anything that you just want to play around with and spike or test out, but NOT commit to your project. That second file, `.idea` really only needs to be there if you use the text editor RubyMine. RubyMine drops an `.idea` file to save your viewing preferences for when you re-open a project. Actually, Macs do the same thing if you open a project in Finder... it drops the `.DS_Store` file in the directory. Neither of those files need to be added and committed to a project. If there are other files that get into your project that aren't necessary project files, just add them to your list and git will totally ignore them too.

What other interesting variables are there in the git config global list?

    alias.loggy=log --oneline --decorate --graph --all
    alias.logg=log --oneline --decorate --graph --all -15
    color.ui=auto

The bottom variable allows for git output to the terminal to be color coded... super awesome! Those top two are aliases that I manually added... How do you think you can add an alias from the command line?

    $ git config --global alias.<alias_name>=<full git command with appropriate flags and spacing>

May I STONGLY suggest that you make sure you are NOT overwriting an existing git command with a poorly chosen alias name, and also TEST the full git command to make sure you are not making a typo or forgetting a flag for your new alias. Once again, to check all your git config global variable settings, run:

    $ git config --global -l

And for the inevitable changing of mind (or errant typo), to clear a set variable:

    $ git config --global --unset <variable>

Keep those aliases limited! Too many and you will forget all the "real" git commands... and you will be limited to your computer.

### [Check out the docs!](http://git-scm.com/docs/git-config)
