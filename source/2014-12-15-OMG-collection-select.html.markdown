---
title: OMG Collection Select
date: 2014-12-15 03:00 UTC
tags: ruby, rails, postgresql, active record
---

Collection select is kind of a badass. Imagine you have a collection of items. You want to choose one of these items from a form and send it back to the controller. The docs aren't super helpful, so here ya go:

    <% form_for @something do |f| %>
      <%= f.label 'Some attribute to associate with Something'%>
      <%= f.collection_select(
            :attribute_id,
            Attribute.all,
            :id,
            :name,
            {include_blank: true},
            {class: "form-control"}
          ) %>
    <% end %>

Wow, that's a lot of arguments! Collection Select takes four to six arguments. The last two are optional, but if you want to add the last, you need to add the second-to-last. Let's figure out what these things are!

The first argument will be the **key in the param** headed back to the controller. In the case above, the param will be `param[:something][:attribute_id]`.

The second argument is the **collection of objects** the user can select from in the drop-down. This can be passed in from the controller as an instance variable, or an ActiveRecord query.

The third argument is the **value in the param** that will be send back to the controller, and the fourth is the value that the user will see in the drop-down. Both the third and fourth arguments must be *methods* that you can call on the objects in the collection.

The fifth and sixth arguments are options, the fifth being **options for the items in the drop-down**, like whether there should be a blank spot or if an empty selection should say something like "Please select one of the following attributes". The sixth option are the **html options**... this is where you can put classes on the select-box.

For some collection-selection madness, check out my super-alpha Herbal Notebook project!

[Herbal Notebook Github repo](https://github.com/craftninja/herbal-notebook)

[Herbal Notebook App](http://herbal-notebook.herokuapp.com/)

Go forth and select from some collections!
