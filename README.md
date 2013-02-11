# Fruit Exercise

This was an interesting experience, I learned a lot.  I've never used the Sequel gem so a big portion of my time was spent exploring the documentation and learning about the gem.

## How to use

Getting rid of ActiveRecord meant no fancy generators or tasks for models.  I have therefore added a sequel rake file in order to automate certian database tasks.

* 'db:create' - Create the database if it does not exist.
* 'db:drop' - Drop the database if it exists.
* 'db:migrate' - Run the Sequel migrations.
* 'db:reset' - Reset the database (drop the tables and migrate).
* 'db:populate' - Reset and then populate the database with 1 million records.

Running `db:create` and then `db:populate` should be all you need to get going.  Population of the database takes ~2 minutes on my machine.

## The Dataset Model

The model has a bunch of methods that go unused in the actual implementation, but I can see them being useful if the requirements were different.  I wrote them because I thought they would be useful in solving the problem at hand but in the end I thought of better solutions which I used instead.  Since I bothered to write tests for them I left them in, I didn't think it would hurt.

## Other comments

I would have attempted to write tests for the rake tasks but that is another area where I do not have any experience.  I may get around to it but it seems to work as expected in my manual testing.