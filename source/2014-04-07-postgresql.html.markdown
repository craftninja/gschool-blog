---
title: Basic Database with PostgreSQL
date: 2014-04-07 03:00 UTC
tags: database, terminal, postgres, scotch
---


For some reason databases have been calling to me for many many years.

I have thus far moderately ignored the sirens' call... dude, I know there are rocks over there. And hello, spreadsheets exist.

Well, the sirens finally hired some people to install lighthouses and buoy markers (yaay for gSchool). Off to meet the sirens.

So databases are cool. Databases are super great at storing tons of information. Sounds boring, but information is the core of so many great things. Like... scotch. Lets make a scotch database.

First you will need to install PostgreSql. Luckily for me (and you!) my awesome instructors at gSchool prepared [a simple tutorial](http://tutorials.gschool.it/postresql_basics) to get us up and running.

First, we will need to create a database. This is kind of like making a project folder. Within this database, we will create a single table or many tables, kind of like files in a project folder. These tables can be related to each other in interesting ways, but for now, we will just make one table in our database.

In the terminal, enter the following text:

<pre><code>
$ psql -d postgres -U username
</code></pre>

So above we are saying "hey, psql (postgresql)", "please connect to the database", "known as postgres", "with the username", "username". If you followed that tutorial link above, your username might be gschool_user. After you enter this command, you will be running the postgres server.

<pre><code>
postgres => CREATE DATABASE delicious_scotch;
</code></pre>

So here we are in the postgres server, in the database "postgres". I will be using the convention of capitalizing only the postgresql commands. So, as I'm sure you guessed, we are telling the postgres server to "create a ", "database", "named delicious\_scotch". The server will know that you are finished with your command if you END WITH A SEMICOLON. After you enter this command, you will still be "standing in" the postgres database, so we need to scoot over to our new totally amazing "delicious_scotch" database.

<pre><code>
postgres => \c delicious_scotch;
</code></pre>

That "c" does need to be lowercase, by the way. So now we need to create a table to put in all kinds of information about scotch. So what kind of information do we want to include? Name, of course... and maybe the region it is from, it's basic flavour profile, age and price. So these pieces of information will be included in creating our table...

<pre><code>
delicious_scotch => CREATE TABLE scotch
delicious_scotch -> (id SERIAL PRIMARY KEY,
delicious_scotch -> name CHARACTER VARYING(255),
delicious_scotch -> region CHARACTER VARYING(255),
delicious_scotch -> flavour CHARACTER VARYING(255),
delicious_scotch -> age INTEGER,
delicious_scotch -> price NUMERIC);
</code></pre>

Wow, that's a lot of things! And did you notice that the second and subsequent lines only have one dash in their arrows? That is because we didn't end any of those lines with a semicolon, and postgress is awaiting more information before executing that command. Once we put in a semicolon, that command will be sent. Lets break the rest of that down. CREATE TABLE... you can guess what that does. The name of the table is "scotch" and the column labels are within the parenthesis separated by commas. Lower case words are the actual labels and the upper case words are the constraints on the kind of data that is allowed. Therefore, "id" is a number that is totally unique and assigned during the creation of that row (don't worry about entering this information, the server will handle it). Any "name", "region", or "flavour" will be characters up to 255, "age" will be an integer, and "price" will be some kind of number. Lets add my favourite scotch, Talisker. We will add the 10 year.

<pre><code>
delicious_scotch => INSERT INTO scotch(name, region, flavour, age, price)
delicious_scotch -> VALUES ('Talisker', 'Islay', 'full-bodied and smokey', 10, 65);
</code></pre>

As you can see above, the list of labels for the table "scotch" is in the same order as the list of values. This will allow the information to be stored in the correct place. ALSO NOTE, we are using single quotes for our strings. Let's add a few more scotches.

<pre><code>
delicious_scotch => INSERT INTO scotch(name, region, flavour, age, price)
delicious_scotch -> VALUES ('Lagavulin', 'Islaay', 'full-bodied and smokey', 16, 80);
delicious_scotch => INSERT INTO scotch(name, region, flavour, age, price)
delicious_scotch -> VALUES ('Knockando', 'Speyside', 'fruity and delicate', 12, 50);
delicious_scotch => INSERT INTO scotch(name, region, flavour, age, price)
delicious_scotch -> VALUES ('Ardbeg', 'Islay', 'full-bodied and smokey', 10, 60);
</code></pre>

Let's see what is in our table...

<pre><code>
delicious_scotch => SELECT * FROM scotch;
                         delicious_scotch
 id |   name    |  region  |        flavour         | age | price
----+-----------+----------+------------------------+-----+-------
  1 | Talisker  | Islay    | full-bodied and smokey |  10 |    65
  2 | Lagavulin | Islaay   | full-bodied and smokey |  16 |    80
  3 | Knockando | Speyside | fruity and delicate    |  12 |    50
  4 | Ardbeg    | Islay    | full-bodied and smokey |  10 |    60
(4 rows)
</code></pre>

Well, that looks pretty good, don't you think? Wait a minute! Oh no, we misspelled "Islay" in row 2! Let fix that.

<pre><code>
delicious_scotch => UPDATE scotch SET region='Islay';
</code></pre>

Do you think we updated that correctly?

<pre><code>
delicious_scotch => SELECT * FROM scotch WHERE id=2;
                        delicious_scotch
 id |   name    | region |        flavour         | age | price
----+-----------+--------+------------------------+-----+-------
  2 | Lagavulin | Islay  | full-bodied and smokey |  16 |    80
(1 row)
</code></pre>

Much better. Lets say you decide that you only want this table to contain scotches from the Islay region... shall we get rid of that Knockando?

<pre><code>
delicious_scotch => DELETE FROM scotch WHERE id=3;
delicious_scotch => SELECT * FROM scotch;
                        delicious_scotch
 id |   name    | region |        flavour         | age | price
----+-----------+--------+------------------------+-----+-------
  1 | Talisker  | Islay  | full-bodied and smokey |  10 |    65
  4 | Ardbeg    | Islay  | full-bodied and smokey |  10 |    60
  2 | Lagavulin | Islay  | full-bodied and smokey |  16 |    80
(3 rows)
</code></pre>

The order is a little weird because the last record in this list that we updated was the Lagavulin. We also could have said "DELETE FROM scotch WHERE region = 'Speyside';". Anyway, come to find out, your bestest friend has been working on the same exact project, and her table is much more extensive than yours... Lets drop this little table.

<pre><code>
delicious_scotch => DROP TABLE scotch;
</code></pre>

Oh yeah, lets get rid of the database too. We'll have to move out of the delicious_scotch database to remove it.

<pre><code>
delicious_scotch => \c postgres;
postgres => DROP DATABASE delicious_scotch;
</code></pre>

Is that database really gone?

<pre><code>
postgres => \l;
</code></pre>

Looks like it's gone! And now to say goodnight to sweet server postgres...

<pre><code>
postgres => \q;
</code></pre>

