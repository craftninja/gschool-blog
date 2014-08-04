---
title: Basic Active Record Validations
date: 2014-08-04 03:00 UTC
tags: ruby, rails, postgresql, active record
---

Salutations!

Let's play with Active Record Validations! We will start by cloning our [user auth project from earlier](https://github.com/craftninja/blog_user_auth). I will also add a "validations_start" tag to the resultant project from this project listed below.

I'm sure you know to "Red, Green, Refactor", but what we really want to remember is "Make a test(RED), Write code to explicitly and exclusively to get that test green (GREEN), then refactor keeping that test green (REFACTOR)." If you are writing feature code with green tests, you are spiking and need to toss all that code once you have learned what you think you need to. If you are refactoring and your tests are getting redder and redder, checkout that last commit and start over.

Validations only work on objects that you are trying to save to the database, objects that are Active Record Objects. Something that we already have in this project that fits this profile is the <code>users/create</code> action. Check out the model for <code>user</code>. Looks like we already have a validation in there from <code>bcrypt</code>! The validator <code>has\_secure\_password</code> will make sure that you have a password, password confirmation, and that they match. Let's write a test for those scenarios.

Create a file <code>user_spec.rb</code> inside a folder <code>models</code> inside the <code>spec</code> directory. Add the following:

    require 'spec_helper'
    
    describe User do
      it 'validates that user must enter password' do
        user = User.new
        user.email = 'mike@example.com'
        expect(user.valid?).to be(false)
        user.password_confirmation = 'password'
        expect(user.valid?).to be(false)
        user.password = 'another_password'
        expect(user.valid?).to be(false)
        user.password = 'password'
        expect(user.valid?).to be(true)
      end
    end

Oh look at that, looks like <code>has\_secure\_password</code> is doing quite a bit for us. Let us add a test to our features making sure validations are showing up in the view...

    scenario 'Users password and password confirmation must match' do
      visit '/'
      click_on 'Sign up'
      fill_in 'Email', with: 'branwyn@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'another_password'
      click_on 'Sign up'
      expect(page).to have_content 'Oh no bad things!'
    end

Uhhhh... do we really want to say 'Oh no bad things!'? Well, sometimes I don't really have strong feelings on the exact wording on validation errors or whatnot, so "expect" the page to have some sillyness in it. I know that that test will never pass, but will be able to pull the actual error message out once things are wired up correctly. Or, I can actually try and get that to show in the view. Run that test.

Great! A failing test! Now we can write some new code. How do we see that error on the page? Let's go to the [RailsGuides](http://guides.rubyonrails.org/). Click on Guides Index, Active Record Validations, and then scroll down to the chapter 8 link [Displaying Validation Errors in Views](http://guides.rubyonrails.org/active_record_validations.html#displaying-validation-errors-in-views). Be sure to reference this guide with any little question, as there is a wealth of information here if you understand how to find and read the docs. The more you use the RailsGuides, the more sense they will make to you.

Looks like we need to copy that first code block and edit it! I like to edit down to something like this:

    <% if @post.errors.any? %>
      <div class="errors"
        <% @post.errors.full_messages.each do |msg| %>
          <p><%= msg %></p>
        <% end %>
      </div>
    <% end %>

Of course we will be using that validation for <code>@user</code>. Paste that code above your form for registration, and run that test again. Aha! There is the default validation message, and just copy and paste that into your test. Let's check that out in the browser.

Ew, why are things jumping all around for different error messages? Inspect one of the elements that did not validate... there is a new class on that from our validations code above... Rails automatically adds a div with <code>class="field\_with\_errors"</code> to each field that does not pass validation... and apparently that div needs some css to not be so greedy with lines. Go to the <code>app/assets/stylesheets/application.css</code> file and add the following:

    .field_with_errors {
        display: inline-block;
    }

You know, let's also make our error messages a lovely deep red color. Add this to the same css file:

    .errors {
        color: maroon;
    }

Lovely! Let's check it out in the browser and commit these changes.

Ok! What happens in our browser when we try to register without putting in an email? Whaaaaaaat? That makes no sense whatsoever! You can't register without putting in a user email! Let's add a test to our model test.

    it 'validates that user must enter an email' do
      user = User.new
      user.password = 'password'
      user.password_confirmation = 'password'
      expect(user.valid?).to be(false)
      user.email = 'mike@example.com'
      expect(user.valid?).to be(true)
    end

Cool, we have a failing test! How to we add a validation? Validations go in the model files... open the user model in the model directory. Add the following line:

    validates_presence_of :email

Alrighty, run that test. Yay! Let's check that out in the browser. Oh, thank goodness. And the validation error shows up as we already put that in our view. Perfect! Let's commit!

So to recap, here is the lowdown on validation errors:

1. Validation takes place on an Active Record object when you try to create or update that object
1. Validation constraints are placed in the Active Record object's model file
1. Validation errors are generated on the Active Record object by Active Record and Rails (with the first word in the error message being the name of the field, and the message content generated by the type of validation constraint)
1. Validation errors are placed in a view by calling Active Record methods on the Active Record object containing the error (<code>@object.errors.full\_messages.each do |message| ... end</code>) which will be already being passed to the view... you are probably using it in your <code>form\_for @object ...</code>


### Mad props to [Mike Gehard](https://twitter.com/mikegehard)

+ for being awesome at refactoring crazy messy drippy code
+ for being a stickler for "Red, Green, Refactor"
+ and for explaining "Red, Green, Refactor" into usable information

### [Check it out on GitHub!](https://github.com/craftninja/blog_user_auth_validations)
