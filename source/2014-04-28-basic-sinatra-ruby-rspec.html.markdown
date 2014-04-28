---
title: Creating a Basic Web App with Sinatra
date: 2014-04-28 03:00 UTC
tags: ruby, sinatra, rspec
---

Greetings and Salutations.

Today we are going to make a basic web app from scratch using Sinatra. Let's get this party started!

    $ mkdir love_notes
    $ cd love_notes
    $ git init
    $ bundle init

Alrighty, what gems do you think we need? Well, we will need Sinatra for production for sure, so that can just go in and not be in a specified gem group. We will also need rspec, of course, and capybara for "driving" some website testing, and let's throw rerun in there for goodness sake. Those three gems can be in the test and development group, so your <code>Gemfile</code> might look like this:

    source "https://rubygems.org"

    gem 'sinatra', '~>1.4.5'

    group :test, :development do
      gem 'rerun', '~> 0.9.0'
      gem 'rspec', '~> 2.14.1'
      gem 'capybara', '~> 2.2.1'
    end

If you place your gems into groups, production deployment will skip loading those gems. This results in not having unnecessary code running in production servers... and can minimize security risks in the rare case of gem tampering! Remember to check [RubyGems](http://rubygems.org/) for the latest versions of gems. It's super easy to copy the exact line of code you need in your <code>Gemfile</code> from good 'ole RubyGems.

Next we will bundle install, initialize rspec, and commit the two Gemfiles and rspec file as our initial commit for the project.

    $ bundle install
    $ rspec --init
    $ git add Gemfile Gemfile.lock .rspec
    $ git commit -m "Gemfiles, .rspec. Inital commit."

If you run git status, you will see that there is still a <code>spec\_helper</code> file hanging about... we are about to get that guy ready for action, so we skipped committing him in that last one. The other files were good to go. Let's put some more information in our <code>spec\_helper</code> file, and delete all those pesky comments while we are at it.

So these are the lines of code we want to add at the top of the <code>spec\_helper</code> file, once we have deleted all those comments.

    ENV['RACK_TEST'] = 'test'
    require 'capybara/rspec'

What is that <code>ENV</code> thing? And how does it work? Well, we are getting ready to write some specs (a.k.a. tests) for our soon to be sweet app. This <code>spec\_helper</code> file is going to be 'required' at the top of any of our created spec files. Each time we run a test, the test spec file will load the <code>spec\_helper</code>, and add that <code>ENV</code> thingie to our <code>LOAD_PATH</code>, but only temporarily. This is basically telling Ruby: "This is a test, it is only a test. Run this code like it's a *test*." And then when the test is finished executing, the <code>ENV</code> thingie dissipates back into the ether, off the stack. Cool!

That second require is going to allow us to use some special language to write our test... you might hear the cool kids call that DSL, or domain specific language. That just means that there are some special words you can only use in particular contexts... Like when you are using capybara or rspec to run tests.

So that takes care of the test environment... what about running this little app locally? We will need a <code>config.ru</code> file for that. Let's create one in the project directory, and put the following inside:

    require_relative 'love_notes'
    run LoveNotes

Let's fire up that server!

    $ rerun rackup

Wow, did you see how mad your server is at you right now? Jees, so much yelling. Your local server is telling you that it cannot find this thing you call <code>love\_notes</code>. So we will create that... but first we write our test. Create a new file in the spec directory: <code>love\_notes\_spec.rb</code>. This is what we will put into it:

    require 'spec_helper'
    require_relative '../love_notes'

    Capybara.app = LoveNotes

    feature 'User can interact with anonymous love notes' do
      scenario 'User can add anonymous love note' do
        visit '/'
        love_note = 'Dear baby kale, thank you for being delicious.'
        expect(page).to have_no_content(love_note)
        fill_in 'Love Note', with: love_note
        click_on 'Send some Love'
        expect(page).to have_content(love_note)
      end
    end

My goodness, that is a lot of words. What does it meeeeeean? Well, we did talk about requiring the <code>spec\_helper</code> at the top of all our spec files, and <code>love\_notes\_spec.rb</code> is a spec file... We also need to specify the application for our app... we kind of do this twice. Once, we specify where our app file is found (<code>require\_relative '../love\_notes'</code>), then we specify the name of the app to run(<code>Capybara.app = LoveNotes</code>). As in our previous post, the name of the class defined in our file matches the name of the file, so <code>LoveNotes</code> will obviously lie in our <code>love\_notes.rb</code> file. So romantic!

And after that comes all that DSL we talked about. Essentially we are "walking through" the app exactly the way we want to create functionality. Now we will get this test to pass, step by step. Let's run rspec in our terminal.

    $ rspec

Our first rspec error complains that rspec cannot find the <code>love\_notes</code> file (just like our server is still complaining about now). That's because we haven't created it yet! Create that file in our project directory, and run rspec again. Now rspec says there is an uninitialized constant. Add the following to the <code>love\_notes.rb</code> file:

    class LoveNotes
    end

When we run rspec again, we get a new error.

    Failure/Error: visit '/'
    NoMethodError:
      undefined method `call' for LoveNotes:Class
    # ./spec/love_notes_spec.rb:8:in `block (2 levels) in <top (required)>'

Ok, that one is a little more confusing. I'll just tell you and spare you all the pain of Google searching and Stack Overflow sifting. It is Sinatra! Our new little app has to inherit some behavior from the Application portion of Sinatra. There are two things we need to do here, tell the <code>LoveNotes</code> class what the name of the class it should inherit from, and then where to find that class information.

    require 'sinatra/base'

    class LoveNotes < Sinatra::Application
    end

And what does rspec think about that?

    Failure/Error: fill_in 'Love Note', with: love_note
    Capybara::ElementNotFound:
      Unable to find field "Love Note"
    # ./spec/love_notes_spec.rb:11:in `block (2 levels) in <top (required)>'

Ah! We are ready to start really writing this app! We now need to get the app to properly process a "get" request for the homepage which will send us to <code>index.erb</code>, and then we need to put a form on the <code>index.erb</code> file with the field "Love Note" inside it. Let's do it! First we will add a <code>get</code> router to our <code>love\_notes</code> app.

    require 'sinatra/base'

    class LoveNotes < Sinatra::Application
      get '/' do
        erb :index
      end
    end

And now we will add the <code>index.erb</code> file. Create a new folder in the project directory named <code>views</code>, and then put <code>index.erb</code> into that folder. The form could look like this:

    <form action="/" method="post">
      <input type="text" placeholder="Love Note" name="love_note">
      <input type="submit" value="Send some Love">
    </form>

So what is happening here? Well, we had a <code>get '/'</code> route defined in our <code>love\_notes.rb</code> app, and now according to line 1 we are going to do something called <code>post '/'</code>. We will have a field called "Love Note" that will accept text, and the incoming data will be known as <code>love_note</code>. We will then have a submit button with the words "Send some Love". But, wait a minute, that's not a real html document! Where is the head, where is the body? Brace yourself for some rad little coding. Create another document in views named <code>layout.erb</code> and put this in it...

    <!DOCTYPE html>
    <html>
    <head>
      <title>Love Notes</title>
    </head>
    <body>
    <h1>Check out these sweet Love Notes.</h1>
    <hr>
    <%= yield %>
    </body>
    </html>

Rack it up if you stopped your server, or refresh your browser and just see what happens. Whaaaaat? Magic.

Wait, what were we doing? Ah yes, now we need to <code>post</code> that sweet little note. Back to the app, <code>love_notes.rb</code>.

    require 'sinatra/base'

    class LoveNotes < Sinatra::Application

      get '/' do
        erb :index
      end

      post '/' do
        params[:love_note]
      end

    end

What is that params thing? Remember how we said the incoming data will be known as <code>love\_note</code>? well this handy dandy params thing is going to help us use that information. Basically we are saying, when a post request for '/' comes in, just show the value of the variable <code>love\_notes</code> that just came in. Rspec says yes. Shall we check it out locally? Go to the localhost listed on your server rackup, most likely <code>http://localhost:9292/</code> and write yourself a love note. "Dear Brie Cheese, I love you so much I could eat you every day."

Let's make a commitment!

    $ git status

My oh my that is a lot of files... six, to be exact. Add them all, one by one.

    $ git add config.ru love_notes.rb spec/spec_helper.rb
    $ git add spec/love_notes_spec.rb views/index.erb views/layout.erb
    $ git commit -m "User can add love note and see that note."

Wait! Don't push that code if you have initialized a remote repository. We are going to do something cool on our next commit.

Our test passes, but we really aren't showing a list of love notes on our index page. How are we going to save those notes? There are several possibilities here. We could save those notes in an array, a hash, a csv file, or a database. The CSV file and database have an advantage because the notes won't get disappeared when the server restarts... but lets save that one for next week. We will keep it simple and use an array. We really don't need to index these notes, so that seems reasonable. First we add our <code>LoveNoteLibrary</code> within the class LoveNotes and before the get route.

    LoveNoteLibrary = Array.new

Next we will "shovel" the new love note into <code>LoveNoteLibrary</code> within the post route. After we add that new note, we will redirect to the index page, and there we will show all the notes.

    post '/' do
      LoveNoteLibrary << params[:love_note]
      redirect '/'
    end

At this point if you run rspec, you will get a good fail... we now are redirecting the <code>post</code> to <code>index.erb</code>, which currently does not have any love notes. So now we need to go to the index and make sure we are showing all those notes. Underneath the form on the index page, add the following code.

    <hr>
    <% LoveNoteLibrary.each do |note|%>
    <%= note %>
    <% end %>

Run that rspec again... looking good! But you know, it would be nice to have those notes in an unordered list, doncha think?

    <hr>
    <ul><% LoveNoteLibrary.each do |note|%>
    <li><%= note %></li>
    <% end %>
    </ul>

Actually, let's get crazy. We don't want bullets for bullets, we want ♥hearts♥! Add some new code within the <<code>head</code>> of the layout page.

    <style>
      ul {
        list-style-type: none;
      }
      ul li:before {
        content: "\2665 \0020";
      }
    </style>

What the heck is that? That, my friend, is CSS. An Internal Style Sheet, as opposed to the External Style Sheet which you may be more familiar with (or frightened of?). Basically you are saying that you want an unordered list with no bullet points, and then you want to put a heart (2665) and a space (0020) before each item in the list. Thanks, [Google search result](http://www.artishock.net/coding/css-list-styling-using-ascii-special-characters/)!

Run rspec, check out the glory in your browser, and don't forget to pump that fist. Oh, should we maybe commit? Lets overwrite our last commit, BECAUSE YOU DIDN'T PUSH IT, right? No amending pushed commits. That's against the rules.

    $ git add love_notes.rb views/index.erb views/layout.erb
    $ git commit --amend -m "User can add love notes and see them all listed on homepage."
    $ git log --oneline --decorate

    ca89bb9 (HEAD, master) User can add love notes and see them all listed on homepage.
    72a67fc Gemfiles, .rspec. Inital commit.

Super! If you are totally into [CRUD](http://en.wikipedia.org/wiki/Create,_read,_update_and_delete), we just checked the first two boxes off our list. Well done! Next on the list is Update and Delete. Lets do that next week when we start using databases!

### [Check it out in Git!](https://github.com/craftninja/blog_love_notes)