---
title: Rails and Postgres
date: 2014-05-12 03:00 UTC
tags: ruby, programming, rspec, capybara, Rails, postgres
---

Guess what we are going to do today? Make a Rails app using PostgreSQL! Hooray! So what is our project going to be about? Lets make a list of songs and link some hott tunes up in here. CD into the parent directory of where you would like this project directory to live... rails is going to be doing quite a bit of work for us, starting with creation of that project directory.

    $ rails new music_playlist --database=postgresql --skip-test-unit --skip-spring

So since we are going to be using posgreSQL for our database and rspec and capybara for our testing, we need to add those two flags listed above when we create the project. Otherwise, we will need to delete the test unit stuff and change our database later, might as well be tidy and do that now. Lately, spring has veen more problematic than problem solving, so we will skip that too. Is rails done makin stuff yet?

    $ tree music_playlist

Whoa! Rails made tons of files!

    $ cd music_playlist
    $ rails server

Rails server will start the local server, and an alias for this is <code>rails s</code>. Open <code>localhost:3000</code> and it says the database doesn't exist. Let's make one!

    $ rake db:create

Check out localhost now... happy appy! To look in our app for the database name and so forth, check out <code>config/database.yaml</code>. Somewhere buried in those comments is the database information. Feel free to delete those comments. You can also check out your database using the PostgreSQL server... accessing that either by <code>$ rails db</code> or the regular postgres route ([see previous blog post](http://www.emilyplatzer.io/2014/04/07/postgresql.html)).

Let's add the gems rspec-rails and capybara to our Gemfile, and be sure to put them in a test and development group [like we did last time](http://www.emilyplatzer.io/2014/04/28/basic-sinatra-ruby-rspec.html). Look up the gems in [RubyGems](http://rubygems.org/) for the current version.

    $ bundle install
    $ rails generate rspec:install
    $ rake spec

Remember <code>rspec --init</code> in our non-rails rspec projects? In Rails we use <code>rails generate rspec:install</code>. This will create a <code>spec</code> directory for us and place a auto-generated <code>spec_helper.rb</code> file inside of that directory. And we can use <code>rails g</code> or <code>rails generate</code> to run that <code>rpsec:install</code> command. The <code>$ rake spec</code> will tell us that everything is loading properly.

To allow us to use capybara and capybara DSL in our testing, we need to add the line <code>require 'cabybara/rails'</code> after the <code>require File.expand\_path("../../config/environment", \_\_FILE\_\_)</code> of <code>spec\_helper.rb</code> file. Let us run the spec again to make sure everything is still loading properly and we didn't break anything... and then let's commit this monster of a beginning!

    $ rake spec
    $ git init
    $ git status

OMG so many files! This is a special exception to the "never <code>$ git add .</code>" rule

    $ git add .
    $ git commit -m "Initial commit. Rspec, Capybara gems added, running Postgres."

Now it's time to get this party started! Create a new directory <code>features</code> in the spec directory, and then create the file <code>song_spec.rb</code> inside that directory containing the following code:

    require 'spec_helper'

    feature 'User can manage a music playlist' do
      scenario 'User is welcomed on the homepage' do
        visit '/'
        expect(page).to have_content('Welcome to PlaylistLand')
      end
    end

Now we will start running rspec with rake to help us direct the development of our app. After each addition of code, RUN RSPEC AGAIN to follow along and see what we should do next. Start understanding those sweet messages your dear computer is sending you.

    $ rake spec

Looks like we need to define a route. First, we edit the <code>config/routes.rb</code> file. Perhaps we will start by deleting all those comments! Then we add the following within the <code>Rails.application.routes.draw do...end</code>.

    get '/' => 'dashboard#index'

That line of code is going to direct a few things... the name of the new controller file we are about to create will be <code>dashboard\_controller.rb</code>, the name of the class defined within that file will be <code>DashboardController</code>, and there will be a method defined within that class named <code>index</code> (which will point to <code>index.html.erb</code>). Let us go ahead and add a new file in the <code>app/controller</code> folder named <code>dashboard\_controller.rb</code> with the following code:

    class DashboardController < ApplicationController
      def index
      end
    end

The "missing template" indicates that rake spec wants a view. Add a new dir and file <code>app/views/dashboard/index.html.erb</code> with the <code>h1</code> text "Welcome to PlaylistLand". Rake spec again.  Yeah!

    $ git status
    $ git add -N app/ spec/
    $ git add -p
    $ git commit -m "User is Welcomed on the homepage"

Well done! Now we will change the test to reflect direction the app will take... in <code>spec/features/song\_spec.rb</code>, change the spec within the scenario block to the following:

    scenario 'User can add titles, links to the homepage' do
      visit '/'
      song_link = 'Welcome to PlaylistLand'
      title = "Mokadem - 'Mokadem' EP"
      url = 'https://soundcloud.com/thump/sets/mokadem-mokadem-ep'
      click_on song_link
      click_on 'Add new Jam'
      fill_in 'Title', with: title
      fill_in 'URL', with: url
      click_on 'Queue!'
      expect(page).to have_content(title)
      expect(page).to have_content(url)
    end

Rake spec tells us that it cannot find the link. Let's turn that <code>h1</code> into a link.

    <h1><a href="/song">Welcome to PlaylistLand</a></h1>

Looks like we need to add a <code>get</code> route for <code>/song</code>. Add this again to <code>config/route.rb</code>

    get '/song' => 'song#index'

Rspec is now looking for the <code>SongController</code>, wich we will put inside <code>app/controllers/song_controller.rb</code>. We will add this to the file:

    class SongController < ApplicationController
      def index
      end
    end

And now another view... <code>song/index.html.erb</code>. Now rake spec is looking for the "Add new jam" link. Let's add that to the song index!

    <h1>PlaylistLand</h1>
    <hr>
    <a href="/song/new">Add new Jam</a>

Now we add that to the <code>routes</code> file.

    get '/song/new' => 'song#new'

And now we need to add the action 'new' to the Song Controller.

    def new
    end

Next we are told that we are missing a template. Lets add <code>new.html.erb</code> to our <code>views/song</code> folder. This will contain the form for our data entry:

    <form action="/song" method="post">
      <input type="text" placeholder="Title" name="title">
      <input type="text" placeholder="URL" name="url">
      <input type="submit" value="Queue!">
    </form>

Now we need to add a post route to the <code>routes.rb</code> file.

      post '/song' => 'song#create'

Let's add that method to the song controller.

    def create
    end

Now we are missing a template. However, we really don't want a new view for this, we just want to submit that new information in the form to the database, and then render it on the song index page. So let's add some stuff to that method. If you really want rspec to push you to do this, put in that redirect line first, and run your test again.

    song = Song.new
    song.title = params[:title]
    song.url = params[:url]
    song.save
    redirect_to '/song'

Rake spec tells us that we have an uninitialized constant <code>SongController::Song</code>. Check it out in localhost, too. Oh no, what's that? An invalid authenticity token? Go to <code>app/controller/application\_controller.rb</code> and comment out line 4 <code>protect\_from\_forgery with: :exception</code>. Refresh the browser. Ah, now our spec and browser agree. We will add a new file <code>app/models/song.rb</code> with the following code:

    class Song < ActiveRecord::Base
    end

Rake spec is now telling us that the relation "songs" does not exist. No songs table! Shall we create one?

    $ rails g migration CreateSong title:string url:string

This command creates a migration in the <code>db/migrate</code> folder with a timestamp(UTC). Let's open that up and ensure that matches our spec... within the <code>create_table :songs do |t| ... end</code> you will have the following code:

    t.string :title
    t.string :url

Remember that we have that title and url coming in from our form on the <code>/song/new</code> page? Let's run that migration!

    $ rake db:migrate

Nice job! Feel free to again poke around in the database from the command line again at this point. Another cool thing is to use the rails console. You can execute ActiveRecord commands directly on the database, for example to create rows in the table. It's kinda like IRB but works on your development database.

    $ rails console

Ok, back to our program. Rspec is now back to looking for the text "Mokadem - 'Mokadem' EP". So now we need to get that database to iterate in the <code>index.html.erb</code> file. We start that by defining some local variables... within <code>song\_controller.rb</code>, within <code>def index...end</code>:

    @songs = Song.all

Within <code>song/index.html.erb</code>:

    <% @songs.each do |song| %>
      <%= song.title %> | <%= song.url %><br>
    <% end %>

Rspec says green! Let's check that baby out in the browser, and then commit!

    $ git status
    $ git add -N app/ db/
    $ git add -p
    $ git status
    $ git commit -m "User can add song titles and URLs, see songs listed on the song homepage"

Nice! Next up in the CRUD cycle is Update... shall we? Lets have it where when you click the name of the song, you go to the song page, and there there is an edit button which takes you to a page to edit the title or url. Lets add this test to our <code>song_spec</code>.

    scenario 'User can update songs' do
      old_title = 'Touch'
      title = 'Holy Other - Touch'
      url = 'https://soundcloud.com/holyother/touch'
      visit '/song'
      click_on 'Add new Jam'
      fill_in 'Title', with: old_title
      fill_in 'URL', with: url
      click_on 'Queue!'
      click_on old_title
      expect(page).to have_content(old_title)
      expect(page).to have_content(url)
      click_on 'Edit'
      fill_in 'Title', with: title
      fill_in 'URL', with: url
      click_on 'Update'
      expect(page).to have_content(title)
      expect(page).to have_content(url)
    end

Looks like rake spec wants us to make the title link first. Dig in! We will wrap that song title on the index like so:

      <a href="/song/<%= song.id %>"><%= song.title %></a> | <%= song.url %><br>


Rspec tells us we need a new get route.

    get '/song/:id' => 'song#show'

Next, show cannot be found for SongController. We put that in the <code>song\_controller.rb</code>.

    def show
    end

Looks like it's time to create another view. Do you know what it will be called and where it will go? It will be <code>app/views/song/show.html.erb</code>. Rspec now is looking for that title on the show page, and we are going to need to hand that show page a single song. We can do this by adding the following code to that show method:

    def show
      @song = Song.find(params[:id])
    end

Now we need pass that to the show page to display the title, url, and then add the edit link.

    <h3><%= @song.title %> | <%= @song.url %> | <a href="/song/<%= @song.id %>/edit">Edit</a></h3>

And add the get route...

    get '/song/:id/edit' => 'song#edit'

Add the method to the SongController...

    def edit
    end

We will have to pass in the song information indexed by the title link, so add <code>@song = Song.find(params[:id])</code> to the edit method. Then add the view. You know where it goes. I'll just tell you even though you totally know by now... in <code>views/song/edit.html.erb</code>. Running rspec tells us that we need that field "Title". Let's make that form for editing the Song information!

    <form action="/song/<%= @song.id %>" method="post">
      <input type="hidden" name="_method" value="put"/>
      <input type="text" id="Title" value="<%= @song.title %>" name="title"/>
      <input type="text" id="URL" value="<%= @song.url %>" name="url"/>
      <input type="submit" value="Update"/>
    </form>

Whoa, there is some weird stuff going on there. Ok, we want to edit our record... there isn't really a method in browsers to do that. So we sort of make one by changing our method to "put" in that second line. And we would be jerks if we made people add all that information again on the edit page, so we can just fill out that form for the user and allow them to actually edit it. Now we need to add that <code>put</code> route in the routes file.

    put '/song/:id' => 'song#update'

Aaand, add that to our SongController...

    def update
    end

That is going to be a <code>redirect_to '/song'</code>... what are we missing? Looks like we need to collect that information from the form and actually update the database. Our update method in the SongController will finally look like this:

    def update
      song = Song.find(params[:id])
      song.title = params[:title]
      song.url = params[:url]
      song.save
      redirect_to '/song'
    end

Whaaat? I almost forgot what green looked like. Check it in the browser, and commit this lovely beast.

    $ git status
    $ git add -N app/views/song/edit.html.erb app/views/song/show.html.erb
    $ git add -p
    $ git status
    $ git commit -m "User can edit song title and url"

Awesome! We only have delete to go! Let's write that test.

    scenario 'User can delete songs' do
      title = 'Epic Rap Battle - Geek v Nerd'
      url = 'http://www.youtube.com/watch?v=2Tvy_Pbe5NA'
      visit '/song'
      click_on 'Add new Jam'
      fill_in 'Title', with: title
      fill_in 'URL', with: url
      click_on 'Queue!'
      click_on title
      click_on 'Over it!'
      expect(page).to have_no_content(title)
      expect(page).to have_no_content(url)
    end

Looks like we start with the "Over it!" We add this to the show page:

    <form action="/song/<%= @song.id %>" method="post">
      <input type="hidden" name="_method" value="delete"/>
      <input type="submit" value="Over it!">
    </form>

And we add the route...

    delete 'song/:id' => 'song#destroy'

And the method in the <code>SongController</code>. We know this will be a redirect, so add that after running rspec again.

    def destroy
      redirect_to '/song'
    end

Now we need to actually delete that content from our database table. In that destroy method, we again find the song (just like we did in update) and then just use the method destroy like so:

    def destroy
      song = Song.find(params[:id])
      song.destroy
      redirect_to '/song'
    end

What does rspec say? Browser check? Wonderful! Lets do our final commit for this wee project. Nice Job!

    $ git status
    $ git add -p
    $ git status
    $ git commit -m "User can delete songs."

### [Check it out on GitHub!](https://github.com/craftninja/blog_music_playlist)
