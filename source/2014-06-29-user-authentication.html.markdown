---
title: User Authentication from Scratch
date: 2014-06-29 03:00 UTC
tags: ruby, rails, postgresql, user authentication
---

Well, hello there!

Today we are going to start a Rails User Authentication from scratch. This will step-by-step go through everything you need to create basic user registration and login. Basic, people, basic. You can make it pretty later.

    $ rails new user-auth --skip-spring --skip-test-unit --database=postgresql
    $ cd user-auth
    $ git init

Before we commit, let's open up that Gemfile. Delete all those comments (you can leave bcrypt in there) and add the following:

    group :test, :development do
      gem 'rspec-rails', '~> 2.14.2'
      gem 'capybara', '~> 2.2.0'
    end

Personally, I haven't really made great friends with RSpec 3. I am looking forward to that in the *future*.

    $ bundle install
    $ rails g rspec:install

Open up <code>spec_helper</code>, delete all those comments, and add the following below the other <code>require</code>:

    require 'capybara/rspec'

Time to make our first commit! Feel free to <code>git add .</code> here (and only here), there is a lot of new files that Rails just made for ya. Check it out in the browser if you want, but it might bore you to tears. Open up a new terminal window, navigate to our little directoy here, and <code>$ rails s</code>. Then go back to your command line terminal window.

    $ git status
    $ git add .
    $ git commit -m "Initial commit, RSpec, Capybara, PostgreSQL"

Time to get crackin! I'm just going to have you dump all the tests in at once, and you can remove the <code>pending</code> after each commit. Below is your test, put it in a new folder called <code>features</code> in a file <code>user\_auth\_spec.rb</code>:

    require 'spec_helper'
    require 'capybara/rspec'
    
    feature 'Homepage' do
    
      scenario 'User can register' do
        visit '/'
        click_on 'Sign up'
        fill_in 'Email', with: 'branwyn@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        click_on 'Sign up'
        expect(page).to have_content 'Welcome to the lending library branwyn@example.com'
      end
    
      scenario 'User can logout' do
        pending
        email_address = 'branwyn@example.com'
        welcome_message = "Welcome to the lending library #{email_address}"
        visit '/'
        click_on 'Sign up'
        fill_in 'Email', with: email_address
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        click_on 'Sign up'
        expect(page).to have_content(welcome_message)
        click_on 'Log out'
        expect(page).to_not have_content(welcome_message)    
      end
    
      scenario 'User can login with registered email and password' do
        pending
        email_address = 'branwyn@example.com'
        password = 'password'
        welcome_message = "Welcome to the lending library #{email_address}"
        visit '/'
        click_on 'Sign up'
        fill_in 'Email', with: email_address
        fill_in 'Password', with: password
        fill_in 'Password confirmation', with: password
        click_on 'Sign up'
        click_on 'Log out'
        click_on 'Log in'
        fill_in 'Email', with: email_address
        fill_in 'Password', with: password
        click_on 'Log in'
        expect(page).to have_content(welcome_message)
      end
    
      scenario 'User cannot login if their email address does not exist' do
        pending
        email_address = 'branwyn@example.com'
        password = '123456'
        visit '/'
        click_on 'Log in'
        fill_in 'Email', with: email_address
        fill_in 'Password', with: password
        click_on 'Log in'
        expect(page).to have_content 'Email / password is invalid'
      end
    
      scenario 'User cannot sign in with an invalid email and/or password' do
        pending
        email_address = 'branwyn@example.com'
        password = '123456'
        visit '/'
        click_on 'Sign up'
        fill_in 'Email', with: email_address
        fill_in 'Password', with: password
        fill_in 'Password confirmation', with: password
        click_on 'Sign up'
        click_on 'Log out'
        click_on 'Log in'
        fill_in 'Email', with: email_address
        fill_in 'Password', with: 'password'
        click_on 'Log in'
        expect(page).to have_content 'Email / password is invalid'
      end
    end

Let's run that first test!

    $ rspec

Oh, create a database.

    $ rake db:create
    $ rspec

Looks like we need to "root" our app. Open <code>/config/routes.rb</code> and delete all the comments. This should be your only route:

      root 'welcome#index'

Run RSpec again. Just keep running it after every addition to see what is next.

    $ rspec

Now we make add the WelcomeController. Add <code>welcome_controller.rb</code> to <code>/app/controllers/</code> with the following:

    class WelcomeController < ApplicationController
      def index
      end
    end

Running RSpec again tells us we need a view. Add <code>index.html.erb</code> to the new file folder <code>/app/views/welcome/</code>. Run RSpec again, and looks like we need to add a link. We are going to use some rails helpers, so before we actually add that link, add the following routes to our <code>routes.rb</code> file:

    resources :users

Are you curious what you really just did?

    $ rake routes

Whoa. That's a lot of routes right there. Moving on... back to our <code>welcome/index.html.erb</code>:

    <%= link_to 'Sign up', new_user_path %>

Now we need a <code>users\_controller.rb</code> in the same directory as our <code>welcome\_controller.rb</code>. Add the following:

    class UsersController < ApplicationController
      def new
      end
    end

And now a view... add <code>new.html.erb</code> into a new file folder <code>/app/views/users/</code>. Run RSpec again, and looks like we need to add a form for our new user to fill out. We are going to use some rails helpers again, and this is what it looks like:

    <%= form_for @user do |f| %>
      <%= f.label :email %>
      <%= f.text_field :email %>
    
      <%= f.label :password %>
      <%= f.password_field :password %>
    
      <%= f.label :password_confirmation %>
      <%= f.password_field :password_confirmation %>
    
      <%= f.submit 'Sign up' %>
    <% end %>

We can't pass in <code>nil</code>? What does that even mean? Well, that <code>@user</code> isn't getting passed in from our controller... eventually we want that to be a <code>User</code> object. But for that we need a migration. Go to the terminal, and... 

    $ rake g migration CreateUsers email:string password_digest:string

Feel free to check out that migration file in the <code>db</code> folder. We will also need to add a model <code>user.rb</code> in the <code>/app/models/</code> folder. You can delete that <code>.keep</code> file after you add the model file, it's just holding that directory for you when there are no files within it. Within that model file, we will add the following:

    class User < ActiveRecord::Base
      has_secure_password
    end

Uncomment your bcrypt gem in your Gemfile, bundle and run your migration!

    $ bundle
    $ rake db:migrate

Now, add the following within your <code>new</code> method in your <code>UsersController</code>:

    @user = User.new

Yay! We are moving forward. RSpec tells us it is time to actually create this user... add the following below your Users new method:

      def create
        @user = User.new(allowed_parameters)
        if @user.save
          session[:current_user_id] = @user.id
          redirect_to root_path
        else
          render :new
        end
      end
    
      def allowed_parameters
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

And we need to add something to our <code>welcome/index.html.erb</code> above our link:

    <h1>Welcome to the lending library
      <% if @user %>
        <%= @user.email %></h1>
      <% else %>
        </h1>
        <%= link_to 'Sign up', new_user_path %>
      <% end %>

And we need to pass in a user. Let's just pass in the last one created for now, we will make that more workable with "sessions" later. Within the Welcome index method, add:

    @user = User.last

This is obviously not going to work very well. But we have our first green test, and in our next session will refactor that nicely. For now, let's check it out in the browser and commit.

    $ rspec
    $ git status
    $ git add -N app/ db/ spec/
    $ git add -p
    $ git status
    $ git commit -m "User can register"
    
The next step is to remove that <code>pending</code> from our next test and run RSpec. Looks like we need a "Log out" button... however for logging in and out, we will create a new resource in our routes file:

    resources :login

Then add this line to <code>/app/views/welcome/index.html.erb</code> just below the <code>@user.email</code> line:

    <%= link_to 'Log out', login_path(@user), :method => :delete %>

Now we need a <code>LoginController</code>. Add <code>login_controller.rb</code> to <code>/app/controllers/</code> with the following:

    class LoginController < ApplicationController
      def destroy
        @_current_user = session[:current_user_id] = nil
        redirect_to root_path
      end
    end

Now we eventually want to redirect to our root path. But first, we have to get that logged in thing working for real, not just that <code>User.last</code> cheater. We want to add "sessions" to our little app. In our <code>application_controller.rb</code>, we will add the following method:

    def current_user
      @_current_user ||= session[:current_user_id] &&
        User.find_by(id: session[:current_user_id])
    end

And we want to change our <code>WelcomeController</code> to pass in the following to the <code>index</code>:

    @user = User.find_by(id: session[:current_user_id])

RSpec says we are looking good! Let's check it out in the browser and make another commit.

    $ rspec
    $ git status
    $ git add -N app/
    $ git add -p
    $ git commit -m "User can logout, sessions have been added"

Nice! We are well on our way! Let's remove another pending and see what RSpec and our test have in store. Looks like we need a new link to "Log in". Add this above the "Sign up" link in our <code>/app/views/welcome/index.html.erb</code> file:

    <%= link_to 'Log in', new_login_path %>

Next we add the method <code>new</code> to our <code>LoginController</code>. This will create a "new" logged in session. Next we need to add the view. We are going to pass in a new user to the view, so go ahead and add that to our method <code>new</code> in the <code>LoginController</code>:

    def new
      @user = User.new
    end

Now we will add the login form to the view page (new folder and file) <code>/app/views/login/new.html.erb</code>:

    <%= form_for @user, {url: '/login', :method => 'post'} do |f| %>
      <%= f.label :email %>
      <%= f.text_field :email %>
    
      <%= f.label :password %>
      <%= f.password_field :password %>
    
      <%= f.submit 'Log in' %>
    <% end %>

That first line is a little weird... we are creating a view for <code>@user</code> but we want it to post to <code>/login</code> not <code>/user</code>, so we need to add that hash in there. Now we need to have a <code>create</code> method in our <code>LoginController</code>:

    def create
      if user = User.find_by(:email => params[:user][:email]).try(:authenticate, params[:user][:password])
        session[:current_user_id] = user.id
        redirect_to root_url
      end
    end

Yay for green! Check it out in the browser, and let's commit this baby.

    $ rspec
    $ git status
    $ git add -N app/
    $ git add -p
    $ git status
    $ git commit -m "User can log in"

Let's un-pend the next test! What does RSpec say? Whoa, what happened? It's like the login create method just totally broke. Check that <code>LoginController</code> <code>create</code> method out... oh! We have a "happy path" but what happens if the person trying to log in enters the wrong information? We will change that method to look like this:

    def create
      if user = User.find_by(:email => params[:user][:email]).try(:authenticate, params[:user][:password])
        session[:current_user_id] = user.id
        redirect_to root_url
      else
        @user = User.new
        flash.now[:error] = 'Email / password is invalid'
        render :new
      end
    end

Well, we still aren't getting that flash message anywhere... where should we put that? Open the <code>/app/code/layouts/application.html.erb</code> file and add the following just above the <code><%= yield %></code>:

    <% flash.each do |name, msg| %>
      <%= content_tag :div, msg, class: name %>
    <% end %>

RSpec approves! Let's check it out in the browser and commit.

    $ rspec
    $ git status
    $ git add -p
    $ git commit -m "User cannot log in with a unregistered email"

Only one more test to go... let's un-pend! Oh, wow, looks like our previous changes took care of this scenario too... a user cannot login with the incorrect password. Let's amend that commit and commit this and the last together. Check it out in the browser to make sure all is good.

    $ rspec
    $ git status
    $ git add -p
    $ git commit --amend -m "User cannot log in with unregistered email or incorrect password" 

Hooray! We made a super-basic User Authentication from scratch! There is so much more you could add to this project, but now you know the basics.

### [Check it out on GitHub!](https://github.com/craftninja/blog_user_auth)
