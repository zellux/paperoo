Paperoo aims at providing an online discussion service for academic researchers.

Prerequisitions
---
- Ruby 1.9.2
- At least one available database, MySQL / SQLite / PostgreSQL / etc...
- [RVM](http://beginrescueend.com/) is recommended to manage multiple ruby environments

Installation
---

- Install required ruby gems

```
$ bundle install
```

- Copy config/database.yml/example to config/database.yml, and edit the file as you need

- Setup database

```
$ rake db:setup
```

- Load conference data into database

```
$ rake db:data:load
```

Deployment
---
We use [capistrano](https://github.com/capistrano/capistrano) for remote deployment. See config/deploy.rb for more configurations if you want to deploy on your own server.

Administration
---

- Assign the presentation order
  1. First edit `db/position.yml`, add content like this:

         user1: 1
         user2: 2

  2. Run `rake admin:assign_position`.

- Assign assistant
  1. first edit `db/assistant.yml`, add content like this:

         user1: user2
         user2: user1

  2. Run `rake admin:assign_assistant`.

