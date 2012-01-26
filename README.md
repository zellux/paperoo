Paperoo aims at providing an online discussion service for academic researchers.

Prerequisitions
---
- Ruby 1.9.2
- At least one available database, MySQL / SQLite / PostgreSQL / etc...
- [RVM](http://beginrescueend.com/) is recommended to manage multiple ruby environments

Installation
---

1. Install required ruby gems

```
$ bundle install
```

2. Copy config/database.yml/example to config/database.yml, and edit the file as you need

3. Setup database

```
$ rake db:setup
```

4. Load conference data into database

```
$ rake db:data:load
```

Deployment
---
We use [capistrano](https://github.com/capistrano/capistrano) for remote deployment. See config/deploy.rb for more configurations if you want to deploy on your own server.

