---
title: Creating a Web App with Sinatra and PostgreSQL
date: 2014-05-05 03:00 UTC
tags: ruby, sinatra, postgres, rspec, capybara
---

So last week we created an app with Sinatra using an array as our data storage. If you played around with that, you realize that it has a major shortcoming... every time you restart the server, all your data has vanished! Well, that's not really going to work. A much better way to store data is in a database. If that sounds terribly terrifying to you, go back and refresh yourself with the [PostgreSQL](http://www.emilyplatzer.io/2014/04/07/postgresql.html) post and the [Basic Web app with Sinatra](http://www.emilyplatzer.io/2014/04/28/basic-sinatra-ruby-rspec.html) post.

Yay! This is about to get legit. You know how the song starts...

    $ mkdir good_vids
    $ cd good_vids
    $ git init
    $ bundle init

Well, what do gems you think we need? Sinatra, of course, and good ole rerun, rspec, and capybara. And then there are two new guys... pg and sequel. These two gems will handle connections and communications to our PostgreSQL database. So add all those gems to our gemfile, placing rerun, rspec and capybara in a test and development group, and bundle install. Go ahead and commit those two gemfiles as your initial commit.

Now we will get our spec file going. <code>$ rspec --init</code> and add the usual <code>ENV=['RACK\_TEST']='test'</code> at the top of the <code>spec\_helper</code> file. Require <code>'capybara/rspec'</code> as well, since we will be using that to test our project. Be sure and delete all those comments while you are there. Then, let's add a <code>config.ru</code> file pointing to our planned app <code>GoodVids</code>.

    require_relative "good_vids"
    run GoodVids

Let's write our first test in a new file in the <code>spec</code> directory called <code>good\_vids\_spec.rb</code>, and get this Sinatra app up and running!

    require 'spec_helper'
    require_relative '../good_vids'

    Capybara.app = GoodVids

    feature 'User can manage a list of videos' do

      scenario 'User is welcomed on homepage' do
        visit '/'
        welcome = 'Welcome to the amazing collection of Good Vids'
        expect(page).to have_content(welcome)
      end

    end

Don't forget, we are going to run rspec between each code addition. So run that baby and read those error messages! First, of course, we have a <code>cannot load such file -- ../good\_vids</code> error message. Add the <code>good\_vids.rb</code> file to the project directory and run rspec again. Looks like we now have an <code>uninitialized constant</code>. Lets add the <code>class GoodVids</code> to our <code>good\_vids.rb</code> file. What is this method "call" you speak of? It's Sinatra! We need to have our <code>class GoodVids</code> inherit (<code> < </code>) from <code>Sinatra::Application</code>, and <code>require 'sinatra/base'</code>. What does Rspec say now? Looks like it's time to hardcode hello. We will start with a <code>get</code> route defined in our app <code>good\_vids</code>.

    get '/' do
      'Welcome to the amazing collection of Good Vids'
    end

And our first test passes! <code>$ rerun rackup</code> and check it in the browser. Lets commit this. We will add the files to be tracked first, and then we will approve blocks of code. Don't push this commit yet, we will amend the commit later when we have the index really set up.

    $ git status
    $ git add -N .rspec config.ru good_vids.rb spec/spec_helper.rb spec/good_vids_spec.rb
    $ git add -p
    $ git commit -m "User is welcomed at homepage"

Well, that's not really how we want our app to work. Our next step will be to get a real index page going with maybe a layout like we did last time. Our get request will look like this:

    get '/' do
      erb :index
    end

And our <code>layout.erb</code> will be in a <code>views</code> folder...

    <!DOCTYPE html>
    <html>
    <head>
      <title>GoodVids</title>
    </head>
    <body>
    <h1>Welcome to the amazing collection of Good Vids</h1>
    <hr>

    <%= yield %>

    </body>
    </html>

And our index page will... just exist at this point. Create <code>index.erb</code> also in the same folder, and just leave it blank for now. Rspec? Browser? All systems go. Let's amend our previous commit.

    $ git status
    $ git add -N views/layout.erb good_vids.rb
    $ git add -p
    $ git add views/index.erb
    $ git commit --amend -m "User is welcomed at homepage"

We want to add <code>views/index.erb</code> specifically. There isn't any code in the file, so we have do add it outside of the <code>-p</code> staging. Great! We have an app totally up and running!

So there is a cycle of functionality within databases called CRUD... Create, Read, Update, and Destroy. Our first major scenario will be both Create and Read... we will add videos to the database and then be able to see that they are indeed added to the database. This will require several steps:

1. Create the actual database
2. Create the table in the database (and decide what kind of info will be in that table)
3. Get a connection to that database
4. Write to the database (**Create**)
5. Read that database (**Read**)
6. Update rows in the database (**Update**)
7. Delete rows in the database (**Destroy**)

Well let's get started! What shall we do first? Write a test! This will be added to the <code>good\_vids\_spec.rb</code> file after the previous scenario.

    scenario 'User can add videos and see them listed on homepage' do
      visit '/'
      video_name = "Brian Williams Raps 'Rapper's Delight'"
      video_url = 'http://www.youtube.com/watch?v=-YCeIgt7hMs'
      fill_in 'Video Name', with: video_name
      fill_in 'Video URL', with: video_url
      click_on 'Add'
      expect(page).to have_content(video_name)
      expect(page).to have_content(video_url)
    end

Rspec says it can't find the field name "Video Name". We need to make a form. Let's add that to the index.

    <form action="/" method="post">
      <input type="text" placeholder="Video Name" name="video_name"/>
      <input type="text" placeholder="Video URL" name="video_url"/>
      <input type="submit" value="Add">
    </form>

So we are going to <code>post</code> the information gathered by this form to <code>'/'</code>. There are two parameters coming in from this form, <code>video\_name</code> and <code>video\_url</code>. Now we need to hand those two inputs into the <code>post</code> request.

    post '/' do
      "#{params[:video_name]} | #{params[:video_url]}"
    end

And rspec says it's all good. Check that in the browser... not quite done here, but things are working as we outlined them in the spec. Let's commit this and then we will dive into our database refactor. You know how to commit by now, just run <code>git status</code> before you commit to make sure you have everything ready to go.

That <code>post</code> kinda works, but really we want to store this information in the database. Lets create that database. If this seems too scary, remember to go back to the [PostgreSQL blog post](http://www.emilyplatzer.io/2014/04/07/postgresql.html) from a few weeks ago.

So we are going to write a script that will create our databases for us, and then outline the implementation in the README. The script lives in a <code>scripts</code> folder, is named <code>create\_database\_good\_vids.sql</code>, and will be exactly what we would normally write in the postgres server:

    CREATE DATABASE good_vids_development;
    CREATE DATABASE good_vids_test;

Oh look! Two of them. One to mess with in your browser, and one to mess with with your tests. Twins. But only identical for a little while. Let's run the following script in the terminal replacing username with your local postgres server username.

    $ psql -d postgres -U <username> -f scripts/create_database_good_vids.sql

Now for our migration. We will create a <code>migrations</code> folder with a file <code>001\_create\_table\_good\_vids.rb</code> and put the following inside:

    Sequel.migration do
      up do
        create_table(:good_vids) do
          primary_key :id
          String :vid_name, :null=>false
          String :vid_url, :null=>false
        end
      end

      down do
        drop_table(:good_vids)
      end
    end

So the 001 part of the filename tells PostgreSQL which migration number it is on. The migrations will run exactly in order, and PosgreSQL will "know" where it is. Once a migration has been run, it's number is stored and postgres will NEVER RUN any migrations equal to or less than that number. So if you make a mistake and push, just make a new migration that "undoes" your erroneous changes. The number in the front of the file can be 1, or 01, or 00000000000000001... however once you get to the next power of 10 beyond your zeroes, your file system will "read" out of order. Postgres will keep *running* migrations in order, but they won't be *listed* in order.

And let's run that migration script! Remember, you will need to replace the username and password with whatever you have going on locally for YOU. HOWEVER, I would NOT put your actual username and password anywhere in your project (like in your readme...).

    $ sequel -m migrations postgres://<username>:<password>@localhost/good_vids_development
    $ sequel -m migrations postgres://<username>:<password>@localhost/good_vids_test

For other users, or future you, create a README.md in your project folder with the following inside:

    # README

    # create databases

    CD into project directory and run the following in the command line:
        $ psql -d postgres -U <username> -f scripts/create_database_good_vids.sql

    # create tables

        $ sequel -m migrations postgres://<username>:<password>@localhost/good_vids_development
        $ sequel -m migrations postgres://<username>:<password>@localhost/good_vids_test

Did you notice that we have two migrations with two different database names? Our tables inside our two databases are named the same, but the databases are named development and test. Go ahead and commit the database creation script, migration and README. Now we need to get that connection to the database within our project! We will need to do this in two places, our test environment and our actual rack (development) environment. Which files to you think we need to look into? <code>spec\_helper</code> and <code>config.ru</code>! Edit and add this connection to them both just under the require lines.

    DB = Sequel.connect('postgres://user:password@localhost/database_name')

Remember that the database name in your <code>spec\_helper</code> will be the test database and the one in <code>config.ru</code> will be the development.

Mah goodness! What have we done? Rspec, how are you doing? Oh, who is this "Sequel"? Looks like we need to <code>require 'sequel'</code> at the top of those two files with the new database connections. Ok, now rspec is happy. But we still aren't actually using that database. Let's change that up. Head on over to the <code>good_vids</code> app, and lets change up that <code>post</code> route.

    post '/' do
      good_vids_table = DB[:good_vids]
      good_vids_table.insert(
        :vid_name => params[:video_name],
        :vid_url => params[:video_url]
      )
      redirect '/'
    end

Alright! Things are looking good! So we are assigning a local variable <code>good\_vids\_table</code> to the actual database table named <code>good\_vids</code> in our migration, then we are inserting a row: <code>:vid\_name</code> and <code>:vid\_url</code> are the actual names of the columns in that table we created (in that migration from before) and the <code>params[:video\_name]</code> and <code>params[:video\_url]</code> are those incoming data from our form. Whew! Now we will redirect to our index page, where we will need to iterate through that table. Let's get that information accessible in our get request.

    get '/' do
      good_vids_table = DB[:good_vids]
      erb :index, :locals => {:vids => good_vids_table.to_a}
    end

Whoa, that's a new one (for this blog anyway). Well, remember last time when we passed our entire library of love notes into the view? Well, that is not the best way to do things. We don't really want our views to have access to willy-nilly-everything. We want to specifically give the views access to exactly what we want them to have. So we give each view that needs it <code>:locals</code>, or local variables. We pass in what we want to call the variables, in this case <code>:vids</code>, and what that variable is assigned to, in this case <code>good\_vids\_table.to\_a</code>. We tacked that "to array" method on there because the <code>DB[:good\_vids]</code> is a sequel object. We want access to the array form of that information. Let's update the <code>index.erb</code> below the form so we can iterate through that array and show what is in our Good Vids database!

    <hr>
    <ul>
      <% vids.each do |vid| %>
        <li><%= vid[:vid_name] %> | <%= vid[:vid_url] %></li>
      <% end %>
    </ul>

Rspec? Browser? Looking good. Is there anything we want to refactor? Well, it is true that each time we run our test we are putting a duplicate row of the same data in the table. Let's add a <code>before do ... end</code> inside our feature before our first spec.

    before do
      DB[:good_vids].delete
    end

We could check that out in the postgres server to make sure that we don't have a million Brians singing in there. Check rspec and browser again to make sure all is good, and let's commit this guy!

Sweet! Now we are ready for our Read, Update and Delete. We will start with Read, which will be our "show page". When the user clicks on the name of the video, they will be routed to a page with the name, url and eventually an edit and delete link or button. Let's write that test!

    scenario 'User can see show page for videos' do
      visit '/'
      video_name = 'Hey Pass Me A Beer II'
      video_url = 'http://www.youtube.com/watch?v=HVsU-vwUpdM'
      fill_in 'Video Name', with: video_name
      fill_in 'Video URL', with: video_url
      click_on 'Add'
      click_on video_name
      expect(page).to have_content(video_name)
      expect(page).to have_content(video_url)
    end

Let's get started! First we will need to edit the index page...

    <% vids.each do |vid| %>
      <li><a href="/<%= vid[:id] %>"><%= vid[:vid_name] %></a> | <%= vid[:vid_url] %></li>
    <% end %>

Then add the route to the <code>good\_vids.rb</code> app...

    get '/:id' do
      good_vids_table = DB[:good_vids]
      vid = good_vids_table.where(id: params[:herb_id]).first
      erb :show, :locals => {:vid => vid}
    end

Why the method <code>.first</code>? Again, that object coming out is going to be a Sequel object, and we want to be able to access that object's data. Check it out by running rspec in the terminal by putting <code>p vid</code> on a line just under the assignment of <code>vid</code>... Now run rspec with and without that <code>.first</code> method at the end. Cool!

And then of course create that <code>show.erb</code> page in the <code>views</code> folder.

    <%= vid[:vid_name] %> | <%= vid[:vid_url] %>

Rsepc? Browser? Go ahead and commit this.


Now we will add the Update and Delete functionality. We can do this on the show page. We will add an edit link that will take us to an edit page where we can update our video information, and we will also have a delete button. Let's start with the edit test.

    scenario 'User can update videos' do
      visit '/'
      old_video_name = 'BED INTRUDER SONG!!! (now on iTunes)'
      updated_video_name = 'Bed Intruder'
      video_url = 'http://www.youtube.com/watch?v=hMtZfW2z9dw'
      fill_in 'Video Name', with: old_video_name
      fill_in 'Video URL', with: video_url
      click_on 'Add'
      click_on old_video_name
      click_on 'Edit'
      fill_in 'Video Name', with: updated_video_name
      click_on 'Update'
      expect(page).to have_content(updated_video_name)
    end

What does rspec say? Looks like we start with that edit button in the <code>show.erb</code>.

    <%= vid[:vid_name] %> | <%= vid[:vid_url] %> | <a href="/<%= vid[:id] %>/edit">Edit</a>

Now we need to add a get route for that.

    get '/:id/edit' do
      good_vids_table = DB[:good_vids]
      vid = good_vids_table.where(:id => params[:id]).first
      erb :edit, :locals => {:vid => vid}
    end

Now we need to create that <code>edit.erb</code> file within <code>views</code>, of course.

    <form action="/<%= vid[:id] %>" method="post">
      <input type="hidden" name="_method" value="put">
      <input type="text" id="Video Name" value="<%= vid[:vid_name]%>" name="video_name"/>
      <input type="text" value="<%= vid[:vid_url]%>" name="video_url"/>
      <input type="submit" value="Update"/>
    </form>

What is that second line? Well, we want to actually have the method be <code>put</code> instead of <code>post</code>. So that second line there will allow us to have a "put" route in the app as follows:

    put '/:id' do
      good_vids_table = DB[:good_vids]
      good_vids_table.where(:id => params[:id]).update(
        :vid_name => params[:video_name],
        :vid_url => params[:video_url]
      )
      redirect '/'
    end

Rspec? Browser? Prrrrfect. Let us commit. And now to delete. First, the test.

    scenario 'User can delete videos' do
      visit '/'
      video_name = 'Baby Bunny - Parry Gripp'
      video_url = 'http://www.youtube.com/watch?v=aD9xQaDAuQw'
      fill_in 'Video Name', with: video_name
      fill_in 'Video URL', with: video_url
      click_on 'Add'
      click_on video_name
      click_on 'Delete'
      expect(page).to have_no_content(video_name)
    end

And then we add the delete button to the show page.

    <form action="/<%= vid[:id] %>" method="post">
      <input type="hidden" name="_method" value="delete">
      <input type="submit" value="Delete">
    </form>

Another secret hidden route! So now we add a delete route for that guy.

      delete '/:id' do
        good_vids_table = DB[:good_vids]
        good_vids_table.where(:id => params[:id]).delete
        redirect '/'
      end

Rspec? Browser? And commit. Well done! That is the complete cycle of CRUD functionality with Sinatra and Postgres! What are you going to make?

### [Check it out on GitHub!](https://github.com/craftninja/blog_good_vids)
