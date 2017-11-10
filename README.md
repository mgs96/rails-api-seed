# README

The idea of this project is to serve as an API seed project, I will add further
info... later

if you're using [c9.io](https://c9.io/) and you want to upload it to heroku,
chances are you have a legacy version of  heroku-cli, to solve this, copy-paste 
the following in the terminal:

```sh
$ wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh
```
this should update the heroku-cli.

If you were using sqlite3, you must change it to postgresql in order to 
upload the app to heroku, first, in the gemfile, change `gem 'sqlite3'` 
to `gem 'pg'`, then run `bundle install`.

Now, you should change the file `config/database.yml`. Your file should look 
something like this:

```yml
default: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see rails configuration guide
  # http://guides.rubyonrails.org/configuring.html#database-pooling
  pool: 5

development:
  <<: *default
  database: my_database_development

test:
  <<: *default
  database: my_database_test

production:
  <<: *default
  database: my_database_production
```

now you should create the database and run any migrations you have:

```sh
$ rails db:create
$ rails db:migrate
```

If, after running the create command you get this error:

`PG::InvalidParameterValue: ERROR:  new encoding (UTF8) is incompatible with the encoding of the template database (SQL_ASCII)`

the solution is [here](https://stackoverflow.com/questions/16736891/pgerror-error-new-encoding-utf8-is-incompatible)
but I will copy the steps here in case the answers gets deleted, remember to run
this command first: `sudo -u postgres psql postgres`
	
>Ok, below steps resolved the problem:  
First, we need to drop template1. Templates can’t be dropped, so we first modify it so t’s an ordinary database:  
`UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';`  
Now we can drop it:  
`DROP DATABASE template1;`  
Now its time to create database from template0, with a new default encoding:  
`CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE';`  
Now modify template1 so it’s actually a template:  
`UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';`  
Now switch to template1 and VACUUM FREEZE the template:  
`\c template1`  
`VACUUM FREEZE;`  
Problem should be resolved.